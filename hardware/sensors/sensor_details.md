# Sensor Details – Project Astra

This document describes the sensors used in Project Astra for air pollution monitoring and pothole detection.

---

## 1. MPU6050 – Accelerometer & Gyroscope

### Description
The MPU6050 is a 6-axis MEMS sensor that combines:
- 3-axis accelerometer
- 3-axis gyroscope

It is used in Project Astra to detect:
- Road vibrations
- Sudden shocks
- Potholes and road damage

### Key Features
- Communication: I2C
- Operating Voltage: 3.3V – 5V
- High sensitivity motion tracking
- Low power consumption

### Connections (ESP32)
| MPU6050 Pin | ESP32 Pin |
|------------|-----------|
| VCC        | 3.3V      |
| GND        | GND       |
| SDA        | GPIO 21   |
| SCL        | GPIO 22   |
| INT        | Optional  |

### Usage
- Detect abnormal vibration patterns
- Identify pothole severity using ML analysis
- Continuous road condition monitoring

---

## 2. PM2.5 Sensor – Air Pollution (PPM)

### Description
The PM2.5 sensor measures fine particulate matter (≤2.5µm) in the air.
These particles are harmful to human health and contribute to air pollution.

### Key Features
- Measures dust concentration (µg/m³ or PPM)
- Detects smoke, dust, and pollutants
- Suitable for real-time air quality monitoring

### Connections (ESP32 – Analog Type)
| PM2.5 Pin | ESP32 Pin |
|----------|-----------|
| VCC      | 5V / 3.3V |
| GND      | GND       |
| AO       | GPIO 34   |

> GPIO 34 is used as an ADC (Analog Input) pin on ESP32.

### Usage
- Measure air pollution levels
- Identify pollution hotspots
- Trigger alerts when pollution exceeds safe limits

---

## 3. Combined Sensor Use Case

Both sensors work together to provide:
- Real-time air quality monitoring
- Accurate pothole detection
- Data-driven analysis via cloud and ML models

Sensor data is transmitted via Bluetooth/Wi-Fi to the mobile gateway and then processed in the cloud.

---

## Summary

| Sensor  | Purpose |
|--------|--------|
| MPU6050 | Pothole & vibration detection |
| PM2.5  | Air pollution monitoring |

These sensors form the core sensing layer of Project Astra.
