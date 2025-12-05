void tiltHome() {
  client.println("Homing");
  digitalWrite(in1_tilt, !forward);
  digitalWrite(in2_tilt, forward);
  analogWrite(ena_pin_tilt, 150);
  
  //H123 Hvad bruges dette loop til nu? udover blot at vente?
  //Venter til vi rammer
  while (btn_blue_interrupt == false) {
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
  //H123 Igen hvorfor er deltaVoltTilt ikke en input parametre?

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
  //H123 Igen lav de tre ovenstående ind til en ifstatement
  //H123 Nu ser jeg at ovenstående er tæt på en 1-1 copy paste fra Azimut, hvorfor ikke lave en funktion der tager offset + delta volt som input og returnere en velocity + direction?


  digitalWrite(in1_tilt, direction);  //control direction
  digitalWrite(in2_tilt, !direction);
  analogWrite(ena_pin_tilt, velocity);  //control speed
}