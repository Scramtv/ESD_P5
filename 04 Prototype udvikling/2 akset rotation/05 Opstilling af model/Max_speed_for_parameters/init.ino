

//Interrups:
//Azimut:
void IRAM_ATTR PinA_R_azi() {
  if (READ_PIN(pinB_azi) == 1) {  //Pin B is high, Pin A is rising
    pos_azi--;
  } else {  //Pin B is low, Pin A is rising
    pos_azi++;
  }
}

void IRAM_ATTR PinA_F_azi() {
  if (READ_PIN(pinB_azi) == 1) {  //Pin B is high, Pin A is falling
    pos_azi++;
  } else {  //Pin B is low, Pin A is falling
    pos_azi--;
  }
}

void IRAM_ATTR PinB_R_azi() {
  if (READ_PIN(pinA_azi) == 1) {  //Pin A is high, Pin B is rising
    pos_azi++;
  } else {  //Pin A is low, Pin B is rising
    pos_azi--;
  }
}

void IRAM_ATTR PinB_F_azi() {
  if (READ_PIN(pinA_azi) == 1) {  //Pin A is high, Pin B is falling
    pos_azi--;
  } else {  //Pin a is low, Pin B is falling
    pos_azi++;
  }
}

void IRAM_ATTR PinZ_R_azi() {
  if (READ_PIN(pinA_azi) == 1) {  //Pin A is high, Pin Z is Rising
    rot_azi++;
  } else {
    rot_azi--;
  }
}

//Tilt:
void IRAM_ATTR PinA_R_tilt() {
  if (READ_PIN(pinB_tilt) == 1) {  //Pin B is high, Pin A is rising
    pos_tilt--;
  } else {  //Pin B is low, Pin A is rising
    pos_tilt++;
  }
}

void IRAM_ATTR PinA_F_tilt() {
  if (READ_PIN(pinB_tilt) == 1) {  //Pin B is high, Pin A is falling
    pos_tilt++;
  } else {  //Pin B is low, Pin A is falling
    pos_tilt--;
  }
}

void IRAM_ATTR PinB_R_tilt() {
  if (READ_PIN(pinA_tilt) == 1) {  //Pin A is high, Pin B is rising
    pos_tilt++;
  } else {  //Pin A is low, Pin B is rising
    pos_tilt--;
  }
}

void IRAM_ATTR PinB_F_tilt() {
  if (READ_PIN(pinA_tilt) == 1) {  //Pin A is high, Pin B is falling
    pos_tilt--;
  } else {  //Pin a is low, Pin B is falling
    pos_tilt++;
  }
}

void IRAM_ATTR PinZ_R_tilt() {
  if (READ_PIN(pinA_tilt) == 1) {  //Pin A is high, Pin Z is Rising
    rot_tilt++;
  } else {
    rot_tilt--;
  }
}

//tilt motor:
void IRAM_ATTR PinA_R_tilt_motor() {
  if (in1_tilt == 1) {  //Doesnt have direction, so we base it off direction of motor
    pos_tilt_motor++;
  } else {
    pos_tilt_motor--;
  }
}

void attachInt() {
  //Interrups:
  //Azi
  attachInterrupt(digitalPinToInterrupt(pinA_azi), PinA_R_azi, RISING);
  attachInterrupt(digitalPinToInterrupt(pinA_azi), PinA_F_azi, FALLING);
  attachInterrupt(digitalPinToInterrupt(pinB_azi), PinB_R_azi, RISING);
  attachInterrupt(digitalPinToInterrupt(pinB_azi), PinB_F_azi, FALLING);
  attachInterrupt(digitalPinToInterrupt(pinZ_azi), PinZ_R_azi, RISING);

  //Tilt
  attachInterrupt(digitalPinToInterrupt(pinA_tilt), PinA_R_tilt, RISING);
  attachInterrupt(digitalPinToInterrupt(pinA_tilt), PinA_F_tilt, FALLING);
  attachInterrupt(digitalPinToInterrupt(pinB_tilt), PinB_R_tilt, RISING);
  attachInterrupt(digitalPinToInterrupt(pinB_tilt), PinB_F_tilt, FALLING);
  attachInterrupt(digitalPinToInterrupt(pinZ_tilt), PinZ_R_tilt, RISING);

  //tilt motor
  attachInterrupt(digitalPinToInterrupt(pinA_tilt_motor), PinA_R_tilt_motor, RISING);
}

void pinSetup() {
  //Init azi pins
  //Motor:
  pinMode(ena_pin_azi, OUTPUT);
  pinMode(in1_azi, OUTPUT);
  pinMode(in2_azi, OUTPUT);

  //Encoder:
  pinMode(pinA_azi, INPUT_PULLUP);
  pinMode(pinB_azi, INPUT_PULLUP);
  pinMode(pinZ_azi, INPUT_PULLUP);

  //Init tilt:
  //Motor:
  pinMode(ena_pin_tilt, OUTPUT);
  pinMode(in1_tilt, OUTPUT);
  pinMode(in2_tilt, OUTPUT);

  //Encoder:
  pinMode(pinA_tilt, INPUT_PULLUP);
  pinMode(pinB_tilt, INPUT_PULLUP);
  pinMode(pinZ_tilt, INPUT_PULLUP);

  //Encoder_motor:
  pinMode(pinA_tilt_motor, INPUT_PULLUP);

  //buttons:
  pinMode(btn_cw_limit, INPUT_PULLUP);
  pinMode(btn_ccw_limit, INPUT_PULLUP);
}
