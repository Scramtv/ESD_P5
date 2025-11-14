

// AP credentials
const char* ssid = "TARP";
const char* password = "12345678H";  // min 8 characters



void init_wireless() {
  // Start the ESP32 in Access Point mode
  WiFi.softAP(ssid, password);
  Serial.println("TARP Started!");
  Serial.print("Connect your PC to SSID: ");
  Serial.println(ssid);

  IPAddress IP = WiFi.softAPIP();
  Serial.print("ESP32 IP address: ");
  Serial.println(IP);

  // Start TCP server
  server.begin();
  Serial.println("TCP server started on port 1234");
}
