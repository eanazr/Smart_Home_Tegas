
//...http://shawnhymel.com/1675/arduino-websocket-server-using-an-esp32/

#include <WiFi.h>
#include <WebSocketsServer.h>

const char* ssid = "xxxxxxxxx";
const char* password = "xxxxxxx";

const char LOKI[]="S1";
const char LOKI2[]="S2";
const char LOKI3[]="S3";
const char LOKI4[]="S4";
const char LOKI5[]="S5";
String str;
String outCondition = "";
// Globals

WebSocketsServer webSocket = WebSocketsServer(80);


void onWebSocketEvent(uint8_t num,WStype_t type,uint8_t * payload,size_t length){   // Called when receiving any WebSocket message
  switch(type){   // Figure out the type of WebSocket event
    
    case WStype_DISCONNECTED:{   // Client has disconnected
      Serial.printf("[%u] Disconnected!\n", num);
    }
    break;
    
    case WStype_CONNECTED:{   // New client has connected
      IPAddress ip = webSocket.remoteIP(num);
      Serial.printf("[%u] Connection from ", num);
      Serial.println(ip.toString());
    }
    break;

    
    case WStype_TEXT:{  // This is where the input from flutter are handled.....
      outCondition = "";
      //Serial.printf("[%u] Text: %s\n", num, payload);
      
      str=(char*)payload;
      Serial.println(str);
      //Serial.println("apa-apa");
      
      if(str=="S1.0"){
        digitalWrite(2,LOW);
      }
      else if(str == "S1.1"){
        digitalWrite(2,HIGH);
      }
      else  if(str=="S2.0"){
        digitalWrite(21, LOW);
      }
      else  if(str=="S2.1"){
        digitalWrite(21, HIGH);
      }
      else  if(str=="S4"){
        Serial.println("S4");
      }
      else  if(str=="S5"){
        Serial.println("S5");
      }

      if(str == "check"){ 
        if(digitalRead(2) == HIGH){
          outCondition += "LED1onabc";
        }
        else if(digitalRead(2) == LOW){
          outCondition += "LED1offabc";
        }
        if(digitalRead(21) == HIGH){
          outCondition += "LED2on";
        }
        else if(digitalRead(21) == LOW){
          outCondition += "LED2off";
        }
        webSocket.sendTXT(num, outCondition);
        delay(100);
      }
    }
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
  pinMode(21,OUTPUT);
  
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
 
void loop() {
  webSocket.loop();
}
