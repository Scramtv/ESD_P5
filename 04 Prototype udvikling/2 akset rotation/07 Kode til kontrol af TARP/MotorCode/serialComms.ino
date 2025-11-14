
void init_serial() {
  Serial.begin(115200);
  Serial.setTimeout(50); //50 ms timeout
  delay(1000);  //wait for serialport
}

//1 bit is used to define motor (0 = azi, 1=tilt)
//12 bits are required to send 360 degrees with 0.1 degree resolution.
//This is sent as 3600 then divided locally
//3 bits CAN be used for CRC (currently not implemented)
//then ; as end
void get_serial_cmd() {
  if (Serial.available() >= 3) {
    byte recv_bytes[3];
    int read_bytes = Serial.readBytesUntil(';', recv_bytes, sizeof(recv_bytes));
    
    if (read_bytes != 2) {
      while (Serial.available() > 0) Serial.read();  // clear input buffer
      return;
    }

    byte b1 = recv_bytes[0];
    byte b2 = recv_bytes[1];

    uint16_t degrees = (uint16_t)(b1 << 8) | b2;
    bitClear(degrees, 15);
    degrees = degrees>>3;
    float deg = degrees*0.1;

    if (bitRead(b1, 0) == 0) {
      //Serial.print("azi degrees: ");
      //Serial.println(deg);
    } else {
      //Serial.print("tilt degrees: ");
      //Serial.println(deg);
    }
  }
}


void send_serial_pos(float azi_pos, float tilt_pos) {
  //Input should be in degrees
  Serial.print(azi_pos);
  Serial.print(";");
  Serial.print(tilt_pos);
  Serial.println(""); // /n
}