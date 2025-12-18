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
  if (READ_PIN(pinZ_azi) == 1) {  //Pin A is high, Pin Z is Rising
    //rot_azi++;
  } else {
    //rot_azi--;
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
  if (READ_PIN(pinZ_tilt) == 1) {  //Pin A is high, Pin Z is Rising
    //rot_tilt++;
  } else {
    //rot_tilt--;
  }
}
//tilt buttons
void IRAM_ATTR btnYellowInterrupt() {
  yellow_interrupt = !READ_PIN(btn_yellow);
}
void IRAM_ATTR btnBlueInterrupt() {
  blue_interrupt = !READ_PIN(btn_blue);
}
// Samplerate timer interrupt
void IRAM_ATTR timer_callback(void* arg) {
BaseType_t higherWoken = pdFALSE;
    vTaskNotifyGiveFromISR(core1, &higherWoken);
    if(higherWoken) portYIELD_FROM_ISR();
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
  //buttons
  attachInterrupt(digitalPinToInterrupt(btn_blue), btnBlueInterrupt, FALLING);
  attachInterrupt(digitalPinToInterrupt(btn_yellow), btnYellowInterrupt, FALLING);
}

void init_sample_rate_timer() {
    // Declare a timer handle
  esp_timer_handle_t periodic_timer;
  // Define the timer creation arguments
  const esp_timer_create_args_t timer_args = {
    .callback = &timer_callback,
    .name = "my_periodic_timer"
  };
  // Create the timer
  ESP_ERROR_CHECK(esp_timer_create(&timer_args, &periodic_timer));
  // 3. Start the Timer Periodically
  ESP_ERROR_CHECK(esp_timer_start_periodic(periodic_timer, sampleRate));
}
void pinSetup() {
  //Init azi pins
  //Motor:
  pinMode(ena_pin_azi, OUTPUT);
  analogWriteFrequency(ena_pin_azi, 20000); // 19kHz frequency for the PWM signal
   analogWriteResolution(ena_pin_azi, 9); // 2^9 resolution
  pinMode(dir_azi, OUTPUT);
  digitalWrite(ena_pin_azi, 0);
  digitalWrite(dir_azi, 0);
  //Encoder:
  pinMode(pinA_azi, INPUT_PULLUP);
  pinMode(pinB_azi, INPUT_PULLUP);
  pinMode(pinZ_azi, INPUT_PULLUP);
  //Init tilt:
  //Motor:
  pinMode(ena_pin_tilt, OUTPUT);
  analogWriteFrequency(ena_pin_tilt, 20000); // 2kHz frequency for the PWM signal - sets resolution to 2^9 (512)
  analogWriteResolution(ena_pin_tilt, 9); // 2^9 resolution
  pinMode(dir1_tilt, OUTPUT);
  pinMode(dir2_tilt, OUTPUT);
  digitalWrite(ena_pin_tilt, 0);
  digitalWrite(dir1_tilt, 0);
  digitalWrite(dir2_tilt, 0);
  //Encoder:
  pinMode(pinA_tilt, INPUT_PULLUP);
  pinMode(pinB_tilt, INPUT_PULLUP);
  pinMode(pinZ_tilt, INPUT_PULLUP);

  //Encoder_motor:
  pinMode(pinA_tilt_motor, INPUT_PULLUP);
  //buttons:
  pinMode(btn_yellow, INPUT_PULLUP);
  pinMode(btn_blue, INPUT_PULLUP);
}
