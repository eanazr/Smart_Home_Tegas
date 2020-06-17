
//...http://shawnhymel.com/1675/arduino-websocket-server-using-an-esp32/

#include <WiFi.h>
#include <WebSocketsServer.h>
#include <DHT.h>

/*----Initialization----*/
TaskHandle_t SensorRead;

#define dhtpin 18
#define dhttype DHT11
DHT dht(dhtpin, dhttype);

#define ir_first 22
#define ir_second 23

#define ldr 34
 
#define led_1_trig 21
#define servo_garage_trig 19

#define buzzer_1_trig 5

#define motor_trig 4
/*-----------------------*/

/*---------->Global Data<----------*/
float h = 0;
float t = 0;
int trigger1 = 0;
int trigger2 = 0;
int toggle = 0;
String toggleData, temperature = "nan", humidity="nan";
bool manualControl = false;
/*---------------------------------*/

const char* ssid = "TEGAS";
const char* password = "tegasfeb2012";

/*--->Websocket communication string<---*/
const char LOKI[]="S1";
const char LOKI2[]="S2";
const char LOKI3[]="S3";
const char LOKI4[]="S4";
const char LOKI5[]="S5";
String str;
String outCondition = "";
String servo = "Closed;";
String lightLevel = "Dark;";
String fan = "FanOff;";
/*--------------------------------------*/

WebSocketsServer webSocket = WebSocketsServer(80);

void onWebSocketEvent(uint8_t num,WStype_t type,uint8_t * payload,size_t length){   // Called when receiving any WebSocket message
  switch(type){   // Figure out the type of WebSocket event
    
    case WStype_DISCONNECTED:{   // Client has disconnected
      Serial.printf("[%u] Disconnected!\n", num);
      manualControl = false;
    }
    break;
    
    case WStype_CONNECTED:{   // New client has connected
      manualControl = true;
      IPAddress ip = webSocket.remoteIP(num);
      Serial.printf("[%u] Connection from ", num);
      Serial.println(ip.toString());
    }
    break;

    
    case WStype_TEXT:{  // This is where the input from flutter are handled.....
      outCondition = "";
      //Serial.printf("[%u] Text: %s\n", num, payload);
      
      str=(char*)payload;

      if(str != "check"){
        Serial.println(str);
      }

      if(str=="S0.0"){
        manualControl = false;
      }
      else if(str=="S0.1"){
        manualControl = true;
      }

      if(manualControl == true){
        if(str=="S1.0"){
          digitalWrite(2,LOW);
        }
        else if(str == "S1.1"){
          digitalWrite(2,HIGH);
        }
        else  if(str=="S2.0"){
          digitalWrite(led_1_trig, LOW);
        }
        else  if(str=="S2.1"){
          digitalWrite(led_1_trig, HIGH);
        }
        else  if(str=="S3.0"){
          digitalWrite(servo_garage_trig, LOW);
        }
        else  if(str=="S3.1"){
          digitalWrite(servo_garage_trig, HIGH);
        }
        else  if(str=="S4.0"){
          digitalWrite(motor_trig, LOW);
        }
        else  if(str=="S4.1"){
          digitalWrite(motor_trig, HIGH);
        }
        
      }
      else{digitalWrite(servo_garage_trig, LOW);delay(10);}

/*------------> This section is to periodically send statuses (e.g: LED status) back to Flutter <------------*/
      if(str == "check"){
        /*-------LED Status-------*/
        if(digitalRead(2) == HIGH){
          outCondition += "LED1on;";
        }
        else if(digitalRead(2) == LOW){
          outCondition += "LED1off;";
        }
        
        if(digitalRead(21) == HIGH){
          outCondition += "LED2on;";
        }
        else if(digitalRead(21) == LOW){
          outCondition += "LED2off;";
        }
        /*------------------------*/
        /*-------Headcount--------*/
        toggleData = String(toggle);
        toggleData += ";";
        outCondition += toggleData;
        /*------------------------*/
        /*------Control mode------*/
        if(manualControl == true){
          outCondition += "ManCont;";  
        }
        else{
          outCondition += "Auto;";
        }
        /*------------------------*/
        /*------Servo status------*/
        if(digitalRead(servo_garage_trig) == LOW){
          servo = "Closed;";
        }
        else if(digitalRead(servo_garage_trig) == HIGH){
          servo = "Opened;";
        }
        outCondition += servo;
        /*------------------------*/
        /*------Temp & Humid------*/
        if(!isnan(t) || !isnan(h)){
          temperature = String(t);
          humidity = String(h);
        }
        outCondition += temperature + ";" + humidity + ";";
        /*-------LDR Status-------*/
        outCondition += lightLevel;
        /*------------------------*/
        /*-------Fan Status-------*/
        if(digitalRead(motor_trig) == LOW){
          fan = "FanOff;";
        }
        else if(digitalRead(motor_trig) == HIGH){
          fan = "FanOn;";
        }
        outCondition += fan;
        /*------------------------*/
        
        webSocket.sendTXT(num, outCondition);
        delay(100);
      }
    }
/*-------------------------------------------------------------------------------------------------------------*/
    break;
   
 
    // For everything else: do nothing
    case WStype_BIN:
    case WStype_ERROR:
    case WStype_FRAGMENT_TEXT_START:
    case WStype_FRAGMENT_BIN_START:
    case WStype_FRAGMENT:
    case WStype_FRAGMENT_FIN:
    default:
      break;
  }
}
 
void setup() {
  pinMode(2,OUTPUT);
  pinMode(ldr, INPUT);
  pinMode(led_1_trig,OUTPUT);
  pinMode(ir_first,INPUT);
  pinMode(ir_second,INPUT);
  pinMode(servo_garage_trig, OUTPUT);
  pinMode(buzzer_1_trig, OUTPUT);
  pinMode(motor_trig,OUTPUT);

  analogReadResolution(10);
  
  dht.begin();

  xTaskCreatePinnedToCore(
    getSensorReading,
    "SensorRead",
    10000,
    NULL,
    1,
    &SensorRead,
    0
  );
  
  Serial.begin(115200);
  
  Serial.println("Connecting");
  WiFi.begin(ssid, password);
  while( WiFi.status() != WL_CONNECTED ){
    delay(500);
    Serial.print(".");
  }
  
  Serial.println("Connected!");
  Serial.print("My IP address: ");
  Serial.println(WiFi.localIP());   // Print our IP address
  
  webSocket.begin();    // Start WebSocket server and assign callback
  webSocket.onEvent(onWebSocketEvent);

}

void getSensorReading(void * pvParameters){
  int dhtCounter = 25;
  int lightVal = analogRead(ldr);
  
  for(;;){
    int counter = 0; //Reset IR counter to 0 every iteration
    toggle = constrain(toggle,0,1000);

/*--------------------> LDR Reading <-------------------*/
    lightVal = analogRead(ldr);
    if(lightVal < 400){
      lightLevel = "Dark;";
    }
    else{
      lightLevel = "Bright;";
    }
/*------------------------------------------------------*/
/*--------------------> DHT Reading <-------------------*/    
    if(dhtCounter == 40){
      h = dht.readHumidity();
      t = dht.readTemperature();
      dhtCounter = 0;
    }
/*------------------------------------------------------*/  
/*-----------------> IR Directional <-------------------*/
    int ir1_status = digitalRead(ir_first);
    int ir2_status = digitalRead(ir_second);  
    if(ir1_status == 0 && trigger2 == 0){
      trigger1 = 1;
      //Serial.print("IR1 activated. Awaiting IR2");
      while(trigger1 == 1){
        if(digitalRead(ir_second) == 0){
          //Serial.println("!");
          toggle++;
          trigger1 = 0;
        }
        else if(counter == 100){
          //Serial.println("");
          trigger1 = 0;
        }   
        counter++;
        delay(10);
      }
    }
    if(ir2_status == 0 && trigger1 == 0){
      //Serial.print("IR2 activated. Awaiting IR1");
      trigger2 = 1;
      while(trigger2 == 1){
        if(digitalRead(ir_first) == 0){
          //Serial.println("!");
          toggle--;
          trigger2 = 0;
        }
        else if(counter == 100){
          //Serial.println("");
          trigger2 = 0;
        }   
        counter++;
        delay(10);
      }
    }
/*--------------------------------------------------------*/ 
/*-------------------> Output section <-------------------*/ 
    if(t > 40){
      digitalWrite(buzzer_1_trig, HIGH);
    }
    else{
      digitalWrite(buzzer_1_trig, LOW);
    }
  
    if(manualControl == false){
      if(toggle > 0 && lightVal < 450){
        digitalWrite(led_1_trig, HIGH);
      }
      else if(toggle == 0 || lightVal >= 450){
        digitalWrite(led_1_trig, LOW);
      }

      if(toggle > 0 && t >= 30){
        digitalWrite(motor_trig, HIGH);
      }
      else if(toggle == 0 || t < 30){
        digitalWrite(motor_trig, LOW);
      }
      delay(10);
    }
    else{
      delay(100);
    }
    dhtCounter++;
  }
}
 
void loop() {
  webSocket.loop();
}
