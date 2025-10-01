/////////////////////////////////////////////////////////////////////////
///////////////// Speed test little motor //////////////////////////////
///////////////////////////////////////////////////////////////////////

//motor control directions
uint8_t motorForward_1 = 2;
uint8_t motorForward_2 = 3;
uint8_t motorBackward_1 = 4;
uint8_t motorBackward_2 = 5;

//buttons
uint8_t button_1 = 6;
uint8_t button_2 = 7;

// micro-time
unsigned long oldTime = 0;
unsigned long time = 0;
unsigned long timeCheck = 0;



void setup() {
  Serial.begin(115200);
  Serial.begin("Speed Test begin!");

  for (int i = 3; i < 6; i++) {
    pinMode(i, OUTPUT);
    digitalWrite(i, 0);
  }
  pinMode(button_1, INPUT_PULLUP);
  pinMode(button_2, INPUT_PULLUP);
}

void loop() {
  analogWrite(3, 100);  // move motor towards button slowly
  digitalWrite(2, HIGH);
  if (button_1 == LOW) {  // if the button is pressed, then start the test
    digitalWrite(2, LOW); //lock in the position
    digitalWrite(3, LOW);
    startTest();
  }
}

void startTest() {
  delay(5000);//get ready to go fast
  oldTime = micros(); //record the time
  analogWrite(5, 255);  // move the motor at full speed
  digitalWrite(4, HIGH);
  timeCheck = micros();
  while(button_2 == HIGH){ //waiting for button to go high
  }
  time = micros();
  digitalWrite(4, LOW); //shutdown motor
  digitalWrite(5, LOW);

  Serial.print("Old Time:"); //print results
  Serial.println(oldTime);
  Serial.print("Time check:");
  Serial.println(timeCheck);
  Serial.print("Finish time");
  Serial.println(time);
  Serial.print("Total time");
  Serial.println(time-oldTime);

  delay(10000); //delay for a long time (10 sec)
}