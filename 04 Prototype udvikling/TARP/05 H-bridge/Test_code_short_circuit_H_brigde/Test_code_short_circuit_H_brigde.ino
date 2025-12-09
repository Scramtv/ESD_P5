//Test code for checking if the H-bridge has been shortet.

const int ena = 13;
const int dir = 14;

void setup() {
 
  pinMode(ena, OUTPUT);
  pinMode(dir, OUTPUT);
  pinMode(15, OUTPUT);

  digitalWrite(ena, 1);
  digitalWrite(dir, 1);
  digitalWrite(15, 1);
}

void loop() {
  analogWrite(ena, 0);
  //delay(1);
  digitalWrite(dir, 0);
  analogWrite(ena, 255);
  delay(1000);
  
  analogWrite(ena, 0);
  //delay(1);
  digitalWrite(dir, 1);
  analogWrite(ena, 255);
  delay(1000);

//   analogWrite(ena, 0);
//   delay(1);
//   digitalWrite(dir, 0);
//   analogWrite(ena, 0);
//   delay(1000);
}
