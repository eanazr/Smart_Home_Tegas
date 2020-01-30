
//...http://shawnhymel.com/1675/arduino-websocket-server-using-an-esp32/

#include <WiFi.h>
#include <WebSocketsServer.h>
const char* ssid = "Scratch";
const char* password = "raspberrypi97";
const char LOKI[]="S1";
const char LOKI2[]="S2";
const char LOKI3[]="S3";
const char LOKI4[]="S4";
const char LOKI5[]="S5";
String str;
// Globals

WebSocketsServer webSocket = WebSocketsServer(80);
// Called when receiving any WebSocket message
void onWebSocketEvent(uint8_t num,WStype_t type,uint8_t * payload,size_t length)
    {
 // Figure out the type of WebSocket event
  switch(type){
 // Client has disconnected
    case WStype_DISCONNECTED:
      Serial.printf("[%u] Disconnected!\n", num);
      break;
    // New client has connected
    case WStype_CONNECTED:
      {
        IPAddress ip = webSocket.remoteIP(num);
        Serial.printf("[%u] Connection from ", num);
        Serial.println(ip.toString());
      }
      break;

    case WStype_TEXT:   // This is where the input from flutter are handled.....
      Serial.printf("[%u] Text: %s\n", num, payload);
      str=(char*)payload;
      Serial.printf("This is the string that we convert: %s",str);
      
//   if (strcmp((const char *)payload, LOKI) == 0)
//      {
//        Serial.println("GOT IT");// handle S1
//      }
//   else
    if(str=="S1")
   {
    digitalWrite(2,HIGH);
    Serial.println(" We got string conversion to work");
   }
   else  if(str=="S2")
   {
    digitalWrite(2,LOW);
    Serial.println(" We got string conversion to work");
   }
   else  if(str=="S3")
   {
    Serial.println(" We got string conversion to work S3");
   }
   else  if(str=="S4")
   {
    Serial.println(" We got string conversion to work S4");
   }
   else  if(str=="S5")
   {
    Serial.println(" We got string conversion to work S5");
   }
  
      break;
//webSocket.sendTXT(num, payload);
     
 
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
  Serial.begin(115200);
  Serial.println("Connecting");
  WiFi.begin(ssid, password);
  while ( WiFi.status() != WL_CONNECTED )
        {
          delay(500);
          Serial.print(".");
        }
  // Print our IP address
  Serial.println("Connected!");
  Serial.print("My IP address: ");
  Serial.println(WiFi.localIP());
  // Start WebSocket server and assign callback
  webSocket.begin();
  webSocket.onEvent(onWebSocketEvent);
}
 
void loop() {
  webSocket.loop();
}
