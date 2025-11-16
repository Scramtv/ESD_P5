
void tiltHome() {
  digitalWrite(dir1_tilt, 0); // homing
  digitalWrite(dir2_tilt, 1);
  analogWrite(ena_pin_tilt, 150);
  
  while (digitalRead(btn_blue) == true) { 
    //wait til the blue wired button is hit, ensuring we home
  }
  //turn off
  analogWrite(ena_pin_tilt, 0);
  digitalWrite(dir1_tilt, 0);
  digitalWrite(dir2_tilt, 0);
  pos_tilt = 0;  //setting starting position to 0
}




//angles given from PC or PI
int angleAzi = 0;
int angleTilt = 0;
int gearing;  //gearing used in the encoders

void controlCode() {

  findSampleRate();

  //Converting volitile variables to non-volitile
  if (xSemaphoreTake(angleMutex, portMAX_DELAY)) {
    angleAzi = targetAzi;
    angleTilt = targetTilt;
    xSemaphoreGive(angleMutex);
  }

  //-----------------TILT CONTROL--------------------
  gearing = 1;  // which gearing is running on the sensor
  float positionInDegrees = convertPulsesToAngle(pos_tilt, gearing);
  float error = angleTilt - positionInDegrees;
  float deltaVolt = error * controllerGainTilt;
  setVelocity(deltaVolt, ena_pin_tilt, tiltOffset);


  //----------------AZIMUT CONTROL-------------------
  gearing = 5;  //gearing on sensor for azimuth
  positionInDegrees = convertPulsesToAngle(pos_azi, gearing);
  error = angleAzi - positionInDegrees;  //calculate error
  deltaVolt = error * controllerGainAzi;
  setVelocity(deltaVolt, ena_pin_azi, aziOffset);
}


//Note: motor = 0 -> Azimut motor
//      motor = 1 -> Tilt motor
void setVelocity(float deltaVolt, int motor, float offset) {

  bool direction = 1;
  float velocity = 0;

  if (deltaVolt < 0) {                   // ensures the offset is inverted if the delta volt is negative
    velocity = offset + abs(deltaVolt);  //get the absolute value, cant use negative values
    direction = 0;                       //change direction
  } else {
    velocity = offset + deltaVolt;
    direction = 1;
  }

  // E123 - ved ikke hvordan jeg ligger det sammen i det andet???
  if (velocity > 255) {  //capping so this is the max speed
    velocity = 255;
  }
  //----------------AZIMUT MOTOR CONTROL-------------------
  if (motor == ena_pin_azi) {
    analogWrite(ena_pin_azi, 0);         // prevents short circuit
    delayMicroseconds(3);                // needed to take care of time delay. Recorded 2.3 us delay from switching
    digitalWrite(dir_azi, !direction);   //control direction
    analogWrite(ena_pin_azi, velocity);  //control speed
  }

  //-----------------TILT MOTOR CONTROL--------------------
  else if (motor == ena_pin_tilt) {
    digitalWrite(dir1_tilt, direction);  //control direction
    digitalWrite(dir2_tilt, !direction);
    analogWrite(ena_pin_tilt, velocity);  //control speed
  }
}


//For sample rate shit
int count = 0;
bool sampleFlag = 0;
long samples[1000];

void findSampleRate() {
  if (count < 100) {
    samples[count] = micros();
    count++;
  } else if (count > 99 && count < 102) {
    Serial.println("Done counting samples---------------------------------");
    sampleFlag = 1;
    count = 103;  //stops further sampling from happening
  }
}
