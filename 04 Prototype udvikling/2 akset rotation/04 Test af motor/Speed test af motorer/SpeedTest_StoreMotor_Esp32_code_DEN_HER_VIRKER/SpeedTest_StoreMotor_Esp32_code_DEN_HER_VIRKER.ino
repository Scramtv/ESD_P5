//////////////////////////////////////////////////////////////////
///////////////////// Big Motor test ////////////////////////////
////////////////// ESP32-S3-DevkitM-1 //////////////////////////
///////////////////////////////////////////////////////////////

//encoder pin
static int pinZ = 40;  //Pin Z
//motor control pins
static int ENA_PIN = 16;  //enable pin controls the motor speed with PWM
static int in1 = 17;  // logic input 1
static int in2 = 18;  //logic input 2

// amount of rotations
volatile int rot = 0;

// timers
unsigned long oldTime = 0;
unsigned long newTime = 0;

void setup() {
  Serial.begin(9600);
  delay(1000);
  //Serial.print("here");
  pinMode(ENA_PIN, OUTPUT);
  pinMode(in1, OUTPUT);
  pinMode(in2, OUTPUT);
  digitalWrite(in1, HIGH);  //These pins control the rotational direction of the motor
  digitalWrite(in2, LOW);   // always just keep this bastard low, only here incase the code no worky-work

  pinMode(pinZ, INPUT_PULLUP); //interrupt pin
  attachInterrupt(digitalPinToInterrupt(pinZ), PinZ_R, RISING);

  Serial.println("Big Motor Test begin");
}


void loop(){
rotateToZero();
fullSpeed();
delay(100000);
}

void rotateToZero() {
  rot = 0;
  analogWrite(ENA_PIN, 150); // rotate the motor slowly till we find a 0
  while (rot == 0) {   //waiting for the interrupt
  }
  analogWrite(ENA_PIN, 0); //stop motor
  Serial.println("start test");
  rot = 0;  // set rotations to 0
}

void fullSpeed() {  //the motor test
  delay(5000);
  oldTime = micros();
  analogWrite(ENA_PIN, 255); //full power baby
  while (rot <= 5) {      //wait for the rotation to hit 5, in total one full rotation
  }
  newTime = micros();
  analogWrite(ENA_PIN, 0);   // stop motor

  //print results
  Serial.print("Old time: ");
  Serial.println(oldTime);
  Serial.print("Time: ");
  Serial.println(newTime);
  Serial.print("Total time: ");
  Serial.println(newTime - oldTime);
}

void PinZ_R() {
  rot++;  // if we get an interrupt we add rotation
}