
//encoder_Azimut pins
static int pinA_azi = 38;  //Pin A
static int pinB_azi = 40;  //Pin B
static int pinZ_azi = 37;  //Pin Z

//Motor_Azimut pins:
static int ena_pin_azi = 13;  //enable pin controls the motor speed with PWM
static int in1_azi = 15;      // logic input 1
static int in2_azi = 14;      //logic input 2

//encoder_tilt pins
static int pinA_tilt = 26;  //Pin A
static int pinB_tilt = 33;  //Pin B
static int pinZ_tilt = 21;  //Pin Z

//Encoder_tilt_motor pins
static int pinA_tilt_motor = 20;  //Pin A

//Motor_tilt pins:
static int ena_pin_tilt = 16;  //enable pin controls the motor speed with PWM
static int in1_tilt = 18;      // logic input 1
static int in2_tilt = 17;      //logic input 2

//btn
static int btn_cw_limit = 41;
static int btn_ccw_limit = 42;

//-------------------------------------------------------------------------------//
#include "soc/gpio_struct.h"
#include "driver/gpio.h"
#include <WiFi.h>
// Fast read
#define READ_PIN(pin) ((pin) < 32 ? ((GPIO.in >> (pin)) & 1) : ((GPIO.in1.val >> ((pin)-32)) & 1))

//Vars for encoder azimut
volatile int pos_azi = 0;
volatile int rot_azi = 0;

//Vars for encoder tilt
volatile int pos_tilt = 0;
volatile int rot_tilt = 0;

//Vars for encoder tilt motor
volatile int pos_tilt_motor = 0;


//Vars for PI controller
float angleDSP //reference input
  error = 0,
  controllerGain = 0.01,
  controllerZero = 0,
  deltaVolt = 0,
  oldDeltaVolt = 0,
  aziOffset = 70 / 255 * 12,   //minimum voltage required for the azimut motor to run
  tiltOffset = 95 / 255 * 12;  //minimum voltage required for the tilt motor to run



WiFiServer server(1234);  // TCP server on port 1234

void setup() {
  Serial.begin(115200);
  delay(1000);  //wait for serialport
  Serial.println("Booted");

  pinSetup();
  attachInt();

  init_wireless();
}

unsigned long lastrun = 0;
unsigned long interval = 10;

void loop() {
  // Wait for a client to connect
  WiFiClient client = server.available();

  if (client) {
    while (true) {
      // temp test code
      String data = client.readStringUntil('\n');
      data.trim();  // Remove any extra spaces, \r, or \n characters

      // 2. Convert the string of characters into an integer number
      angleDSP = data.toInt();

      //get the angle from DSP;
      // angleDSP = inputDSP(); // for future code when DSP is working
      regulator();
    }
  }
}


void regulator() {

  while(error > 5 || error < (-5)){
  float currentPosition = convertPulsesToAngle();

  error = angleDSP - currentPosition;  //find out how far we are from the target
  angleDSP = error; //our angle error is saved here so it changes as we get closer to the target
  deltaVolt = error * controllerGain - controllerZero * oldDeltaVolt;
  oldDeltaVolt = deltaVolt;
  azimutVelocity(deltaVolt);
}
}

void azimutVelocity(float velocity) {
  velocity = aziOffset + deltaVolt;
  bool direction = 0;
  //velocity can only range between 0 and 255
  if (velocity < 0) {
    velocity = velocity * (-1);  //if the motor overshoots and needs to go the other direction
    direction = 1;               // change direction
  }
  if (velocity > 255) {  //capping so this is the max speed
    velocity = 255;
  }

  digitalWrite(in1_azi, direction);  //control direction
  analogWrite(ena_pin_azi, velocity);  //control speed
}


void inputDSP() {  //interface received from DSP
}

float convertPulsesToAngle() {
  float position = (pos_azi / 2500) * 360;  // current position converted to degrees
  pos_azi = 0;                              // reset the counter
  return position;
}
