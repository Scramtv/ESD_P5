void azimutVelocity() {
  float velocity = aziOffset + deltaVoltAzi;
  bool direction = 0;

  if (deltaVoltAzi < 0) {  // ensures the offset is inverted if the delta volt is negative
    velocity = -aziOffset + deltaVoltAzi;
  } else {
    velocity = aziOffset + deltaVoltAzi;
  }

  //velocity can only range between 0 and 255
  if (velocity < 0) {
    velocity = velocity * (-1);  //if the motor overshoots and needs to go the other direction
    direction = !clockwise;      // change direction
    // client.println("Direction change");
  } else {
    direction = clockwise;
  }

  if (velocity > 255) {  //capping so this is the max speed
    velocity = 255;
  }


  // client.print("Velocity corrected: ");  //trouble shooting
  // client.println(velocity);
  // client.print("Direction: ");
  // client.println(direction);

//---Motor output---
  analogWrite(ena_pin_azi, 0);         // prevents short circuit
  delayMicroseconds(3);                // needed to take care of time delay. Recorded 2.3 us delay from switching
  digitalWrite(in1_azi, direction);    //control direction
  analogWrite(ena_pin_azi, velocity);  //control speed
}


void aziInitDirection() {
  bool direction = 0;
  if (angleAzi > 180) {
    angleAzi = 180 - angleAzi;
    direction = !clockwise;  //counter clock wise
    client.println("Counter wise");
  } else {
    direction = clockwise;  //clock wise
    client.println("Clockwise");
  }
}