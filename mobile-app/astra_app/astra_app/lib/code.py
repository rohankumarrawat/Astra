import serial
import requests
import time

# --- UPDATE THIS LINE ---
API_URL = "https://voidpanel.com/predict/" # Ensure the / is at the end!
PORT = '/dev/cu.usbserial-0001'
BAUD = 9600

print("🚀 Cloud Relay Started...")

try:
    with serial.Serial(PORT, BAUD, timeout=1) as ser:
        print(f"✅ Connected to ESP32")
        
        while True:
            if ser.in_waiting > 0:
                line = ser.readline().decode('utf-8', errors='ignore').strip()
                
                if "," in line:
                    parts = line.split(',')
                    if len(parts) == 5:
                        # Make sure we use the correct keys for your specific API
                        payload = {
                            "dust": float(parts[1]),
                            "ax": int(parts[2]),
                            "ay": int(parts[3]),
                            "az": int(parts[4])
                        }
                        
                        try:
                            # Note: We use json=payload to send as application/json
                            response = requests.post(API_URL, json=payload, timeout=2)
                            print(f"📡 Status: {response.status_code} | Data: {payload['ax']}, {payload['ay']}")
                            
                            # If it still says 405, let's see the server's full response
                            if response.status_code == 405:
                                print(f"❌ Server Error Detail: {response.text}")
                                
                            time.sleep(0.1) # Prevent flooding
                        except Exception as e:
                            print(f"⚠️ API Error: {e}")

except Exception as e:
    print(f"❌ Connection Error: {e}")