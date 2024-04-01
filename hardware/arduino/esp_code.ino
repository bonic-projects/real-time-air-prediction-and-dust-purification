#include <Arduino.h>
#include <WiFi.h>
#include <FirebaseESP32.h>
#include <HardwareSerial.h>
// Provide the token generation process info.
#include <addons/TokenHelper.h>
// Provide the RTDB payload printing info and other helper functions.
#include <addons/RTDBHelper.h>
/* 1. Define the WiFi credentials */
#define WIFI_SSID "Autobonics_4G"
#define WIFI_PASSWORD "autobonics@27"
// For the following credentials, see examples/Authentications/SignInAsUser/EmailPassword/EmailPassword.ino
/* 2. Define the API Key */
#define API_KEY "AIzaSyBvKqPRgWXhX-a_UIXwgaYAoumwrmeSfzg"
/* 3. Define the RTDB URL */
#define DATABASE_URL "https://air-guard-127e8-default-rtdb.asia-southeast1.firebasedatabase.app/" //<databaseName>.firebaseio.com or <databaseName>.<region>.firebasedatabase.app
/* 4. Define the user Email and password that alreadey registerd or added in your project */
#define USER_EMAIL "device@gmail.com"
#define USER_PASSWORD "12345678"
// Define Firebase Data object
FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;
unsigned long sendDataPrevMillis = 0;
// Variable to save USER UID
String uid;
//Databse
String path;

//===============================

//DHT11
#include <dht11.h>
#define DHT11PIN 33

float humi=0;
float temp=0;

dht11 DHT11;


//Relay pin

#define relay 26

//Gas Sensors
#define mq7pin  36 //MQ-7
// #define mq4pin 39  Get this data using another esp32
#define mq135pin 34  //MQ-135

int mq7 =0;
int mq4 =0;
int mq135 = 0;

//Dust Sensor
int measurePin = 35;
int ledPower = 14;

unsigned int samplingTime = 280;
unsigned int deltaTime = 40;
unsigned int sleepTime = 9680;

float voMeasured = 0;
float calcVoltage = 0;
float dustDensity = 0;
  
void setup()
{
  
  Serial.begin(115200);


  //Dust SensorLed
  pinMode(ledPower,OUTPUT);


  ///=============
  //WIFI
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  unsigned long ms = millis();
  while (WiFi.status() != WL_CONNECTED)
  {
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();


  //FIREBASE
  Serial.printf("Firebase Client v%s\n\n", FIREBASE_CLIENT_VERSION);
  /* Assign the api key (required) */
  config.api_key = API_KEY;

  /* Assign the user sign in credentials */
  auth.user.email = USER_EMAIL;
  auth.user.password = USER_PASSWORD;

  /* Assign the RTDB URL (required) */
  config.database_url = DATABASE_URL;

  /* Assign the callback function for the long running token generation task */
  config.token_status_callback = tokenStatusCallback; // see addons/TokenHelper.h

  // Limit the size of response payload to be collected in FirebaseData
  fbdo.setResponseSize(2048);

  Firebase.begin(&config, &auth);

  // Comment or pass false value when WiFi reconnection will control by your code or third party library
  Firebase.reconnectWiFi(true);

  Firebase.setDoubleDigits(5);

  config.timeout.serverResponse = 10 * 1000;

  // Getting the user UID might take a few seconds
  Serial.println("Getting User UID");
  while ((auth.token.uid) == "") {
    Serial.print('.');
    delay(1000);
  }
  // Print user UID
  uid = auth.token.uid.c_str();
  Serial.print("User UID: ");
  Serial.println(uid);

  path = "devices/" + uid + "/reading";
}


void updateData(){
  if (Firebase.ready() && (millis() - sendDataPrevMillis > 4000 || sendDataPrevMillis == 0))
  {
    sendDataPrevMillis = millis();
    FirebaseJson json;
    json.set("temp", temp);
    json.set("humi", humi);
    json.set("mq7", mq7);
    json.set("mq4", mq4);
    json.set("mq135",mq135);
    json.set("dust", dustDensity);
    // json.set("gyro_x", gyro_x);
    // json.set("gyro_y", gyro_y);
    // json.set("gyro_z", gyro_z);
    json.set(F("ts/.sv"), F("timestamp"));
    // Serial.printf("Set json... %s\n", Firebase.RTDB.set(&fbdo, path.c_str(), &json) ? "ok" : fbdo.errorReason().c_str());
    Serial.printf("Set data with timestamp... %s\n", Firebase.setJSON(fbdo, path.c_str(), json) ? fbdo.to<FirebaseJson>().raw() : fbdo.errorReason().c_str());
    Serial.println(""); 
  }
}

void loop()
{
  readDht();
  readGas();
  readDust();
  updateData();
}


void readDht(){
  Serial.println();

  int chk = DHT11.read(DHT11PIN);

  humi = (float)DHT11.humidity;
  temp = (float)DHT11.temperature;

  Serial.print("Humidity (%): ");
  Serial.println(humi);

  Serial.print("Temperature  (C): ");
  Serial.println(temp);

  delay(1000);
}

void readGas(){
     mq135 = analogRead(mq135pin);
   mq7 = analogRead(mq7pin);
if (Serial.available() > 0) {
    String value = Serial.readString(); 
    mq4 = value.toInt();
    Serial.print(mq4);
    Serial.flush();
  }
  
  Serial.print("mq7");
  Serial.print(": ");
  Serial.println(mq7);
  
  Serial.print("mq4");
  Serial.print(": ");
  Serial.println(mq4);
  
  Serial.print("mq135");

  Serial.print(": ");
  Serial.println(mq135);
  
  delay(1000);
}

void readDust(){
  digitalWrite(ledPower,LOW);
  delayMicroseconds(samplingTime);

  voMeasured = analogRead(measurePin);

  delayMicroseconds(deltaTime);
  digitalWrite(ledPower,HIGH);
  delayMicroseconds(sleepTime);

  calcVoltage = voMeasured*(5.0/1024);
  dustDensity = 0.17*calcVoltage-0.1;

  if ( dustDensity < 0)
  {
    dustDensity = 0.00;
  }

  Serial.println("Raw Signal Value (0-1023):");
  Serial.println(voMeasured);

  Serial.println("Voltage:");
  Serial.println(calcVoltage);

  Serial.println("Dust Density:");
  Serial.println(dustDensity);

  delay(1000);
}
