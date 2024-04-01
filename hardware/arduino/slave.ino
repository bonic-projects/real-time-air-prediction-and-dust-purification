#include <HardwareSerial.h>

const int MQ4 = 33; // MQ-4 sensor pin

void setup() {
  Serial.begin(115200);
}

void loop() {
  int value1 = analogRead(MQ4);
  Serial.println(value1); // Send value1 over UART
    Serial.flush();
  delay(1000); // Wait for 1 second before reading again
}
