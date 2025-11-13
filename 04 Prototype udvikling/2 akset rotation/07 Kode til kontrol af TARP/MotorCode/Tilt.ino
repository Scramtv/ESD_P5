


void tiltHome() {
  client.println("Homing");
  digitalWrite(in1_tilt, !forward);
  digitalWrite(in2_tilt, forward);
  analogWrite(ena_pin_tilt, 150);
  int i=0;
  while (btn_blue_interrupt == false) {
    //we chilling here till we are home
    //Serial.println("HOMING!!!!!!!");
    //client.println(pos_tilt);
    //client.println(i);
    //vTaskDelay(1);
    i++;
    if(i>1000){
      i = 0;
    }
  }
  //turn off
  analogWrite(ena_pin_tilt, 0);
  digitalWrite(in1_tilt, 0);
  digitalWrite(in2_tilt, 0);
  // client.print("Position: ");
  // client.println(pos_tilt);
  // delay(100); //delay to ensure motor has stopped completely
  pos_tilt = 0;  //setting starting position to 0
  //angleTilt = 10; //need offset for it to work
}


void tiltVelocity() {
  bool direction = 0;
  float velocity = tiltOffset + deltaVoltTilt;

  if (deltaVoltTilt < 0) {  // ensures the offset is inverted if the delta volt is negative
    velocity = -tiltOffset + deltaVoltTilt;
  } else {
    velocity = tiltOffset + deltaVoltTilt;
  }


  //changing direction if velocity is negative
  if (velocity < 0) {
    velocity = velocity * (-1);  //if the motor overshoots and needs to go the other direction
    direction = !forward;      // change direction
    // client.println("Direction change");
  } else {
    direction = forward;
  }

  if (velocity > 255) {  //capping so this is the max speed
    velocity = 255;
  }


  digitalWrite(in1_tilt, direction);  //control direction
  digitalWrite(in2_tilt, !direction);
  analogWrite(ena_pin_tilt, velocity);  //control speed
}