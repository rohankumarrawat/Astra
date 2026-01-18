#include "I2Cdev.h"
#include "MPU6050.h"
#include "Wire.h"

// Hardware Pins
const int dustPin = 34;
const int ledPin = 14;
MPU6050 mpu;

void setup() {
    Serial.begin(9600);
    delay(2000);
    Serial.println("Timestamp,Dust_mg,Accel_X,Accel_Y,Accel_Z"); // CSV Header

    // Initialize Sensors
    Wire.begin(21, 22);
    mpu.initialize();
    pinMode(ledPin, OUTPUT);
    digitalWrite(ledPin, HIGH);

    if (!mpu.testConnection()) {
        Serial.println("MPU6050 connection failed");
    }
}

void loop() {
    // 1. Measure Dust
    digitalWrite(ledPin, LOW); 
    delayMicroseconds(280);
    float vo = analogRead(dustPin);
    delayMicroseconds(40); 
    digitalWrite(ledPin, HIGH); 
    delayMicroseconds(9680);

    float voltage = vo * (3.3 / 4095.0);
    float dust = (voltage * 0.17) - 0.1;
    if (dust < 0) dust = 0;

    // 2. Measure Accel
    int16_t ax, ay, az;
    mpu.getAcceleration(&ax, &ay, &az);

    // 3. Print in CSV format for easy saving
    Serial.print(millis()); Serial.print(",");
    Serial.print(dust, 4); Serial.print(",");
    Serial.print(ax); Serial.print(",");
    Serial.print(ay); Serial.print(",");
    Serial.println(az);

    delay(500); // Record data twice every second
}