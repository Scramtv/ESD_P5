/////////////////////////////////////////////////////////////////////////
///////////////// Speed test little motor //////////////////////////////
///////////////////////////////////////////////////////////////////////



//motor control directions
uint8_t motorForward = 3;
uint8_t motorBackward = 5;
uint8_t ena = 6;


//buttons
uint8_t button_1 = 7;
uint8_t button_2 = 8;

// micro-time
unsigned long oldTime = 0;
unsigned long time = 0;
unsigned long timeCheck = 0;



void setup() {
  Serial.begin(9600);
  while(!Serial){}
  Serial.println("Speed Test begin!");

  pinMode(motorForward, OUTPUT);
  pinMode(motorBackward, OUTPUT);
  pinMode(ena, OUTPUT);
  pinMode(button_1, INPUT_PULLUP);
  pinMode(button_2, INPUT_PULLUP);
}

void loop() {
  digitalWrite(motorForward, HIGH);  // move motor towards button slowly
  analogWrite(ena, 100);

  if (digitalRead(button_1) == LOW) {  // if the button is pressed, then start the test
    digitalWrite(motorForward, LOW); //stop motor and lock in the position
    Serial.println("Begin test");
    startTest();
  }
}

void startTest() {
  delay(5000);//get ready to go fast
  oldTime = micros(); //record the time
  digitalWrite(motorBackward, HIGH);  // move the motor at full speed
  analogWrite(ena, 255);
  timeCheck = micros();
  while(digitalRead(button_2) == HIGH){ //waiting for button to go high
  }
  time = micros();
  digitalWrite(motorBackward, LOW); //shutdown motor
  analogWrite(ena, 0);
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