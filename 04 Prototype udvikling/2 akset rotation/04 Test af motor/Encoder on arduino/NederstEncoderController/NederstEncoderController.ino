static int pinA = 2; //Pin A
static int pinB = 3; //Pin B 
static int pinZ = 19; //Pin Z

volatile int pos = 0;
volatile int rot = 0;

void setup() {
  pinMode(pinA, INPUT_PULLUP);
  pinMode(pinB, INPUT_PULLUP);
  pinMode(pinZ, INPUT_PULLUP);

  attachInterrupt(digitalPinToInterrupt(pinA),PinA_R,RISING);
  attachInterrupt(digitalPinToInterrupt(pinA),PinA_F,FALLING);
  attachInterrupt(digitalPinToInterrupt(pinB),PinB_R,RISING);
  attachInterrupt(digitalPinToInterrupt(pinB),PinB_F,FALLING);
  attachInterrupt(digitalPinToInterrupt(pinZ),PinZ_R,RISING);
  Serial.begin(115200);
}

void PinA_R(){
  cli(); //stop interrupts happening before we read pin values
  if ((PINE & 1<<5)==1<<5){//Pin B is high, Pin A is rising
    pos--;
  }
  else{//Pin B is low, Pin A is rising
    pos++;
  } 
  sei(); //restart interrupts
}

void PinA_F(){
  cli(); //stop interrupts happening before we read pin values
  if ((PINE & 1<<5)==1<<5){//Pin B is high, Pin A is falling
    pos++;
  }
  else{//Pin B is low, Pin A is falling
    pos--;
  } 
  sei(); //restart interrupts
}

void PinB_R(){
  cli(); //stop interrupts happening before we read pin values
  if ((PINE & 1<<4)==1<<4){//Pin A is high, Pin B is rising
    pos++;
  }
  else{//Pin A is low, Pin B is rising
    pos--;
  } 
  sei(); //restart interrupts
}

void PinB_F(){
  cli(); //stop interrupts happening before we read pin values
  if ((PINE & 1<<4)==1<<4){//Pin A is high, Pin B is falling
    pos--;
  }
  else{//Pin a is low, Pin B is falling
    pos++;
  } 
  sei(); //restart interrupts
}

void PinZ_R(){
  cli(); //stop interrupts happening before we read pin values
  if ((PINE & 1<<4)==1<<4){//Pin A is high, Pin Z is Rising
    rot++;
  }
  else{
    rot--;
  } 
  sei(); //restart interrupts
}


void loop(){
  Serial.print("Pos: ");
  Serial.print(pos);
  Serial.print(" , Rot: ");
  Serial.println(rot);
}