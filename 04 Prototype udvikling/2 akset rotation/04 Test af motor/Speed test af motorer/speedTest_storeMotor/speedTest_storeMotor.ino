//////////////////////////////////////////////////////////////////
///////////////////// Big Motor test ////////////////////////////
////////////////////////////////////////////////////////////////

//encoder pin
static int pinZ = 19;  //Pin Z
//motor control pins
static int ena = 3;  //enable pin controls the motor speed with PWM
static int in1 = 4;  // logic input 1
static int in2 = 5;  //logic input 2

volatile int rot = 0;
volatile int pos = 0;

// timers
unsigned long oldTime = 0;
unsigned long newTime = 0;

void setup() {
  Serial.begin(115200);

  pinMode(ena, OUTPUT);
  pinMode(in1, OUTPUT);
  pinMode(in2, OUTPUT);
  digitalWrite(in1, HIGH);  //These pins control the rotational direction of the motor
  digitalWrite(in2, LOW);   // always just keep this bastard low, only here incase the code no worky-work
  pinMode(pinZ, INPUT_PULLUP);
  attachInterrupt(digitalPinToInterrupt(pinZ), PinZ_R, RISING);

  Serial.println("Big Motor Test begin");
}

void loop() {
  rotateToZero();
  fullSpeed();
  delay(1000000);  // just a delay to indicate that the code is done
}

void rotateToZero() {
  rot=0;
  analogWrite(ena, 120);  // rotate the motor slowly till we find a 0
  while (rot == 0) {     //waiting for the interrupt
  }
  analogWrite(ena, 0); //stop motor
  Serial.println("start test");
  rot = 0; // set rotations to 0
}


void fullSpeed() {  //the motor test
  delay(5000);
  oldTime = micros();
  analogWrite(ena, 255); // full speed ahead
  while (rot <= 5) { //wait for the rotation to hit 5, in total one full rotation
  }
  newTime = micros();
  analogWrite(ena, 0); // stop motor

  //print results
  Serial.print("Old time: ");
  Serial.println(oldTime);
  Serial.print("Time: ");
  Serial.println(newTime);
  Serial.print("Total time: ");
  Serial.println(newTime - oldTime);
}



///////////////////////////// interupts ////////////////////////////////

void PinZ_R() {
  cli();                            //stop interrupts happening before we read pin values
  if ((PINE & 1 << 4) == 1 << 4) {  //Pin A is high, Pin Z is Rising
    rot++;                          // we dont care about the direction, just need to count it
  } else {
    rot++;  // we dont care about the direction, just need to count it
  }
  sei();  //restart interrupts
}