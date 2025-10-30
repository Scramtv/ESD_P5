
//encoder_Azimut pins
static int pinA_azi = 38;  //Pin A
static int pinB_azi = 40;  //Pin B
static int pinZ_azi = 37;  //Pin Z

//Motor_Azimut pins:
static int ena_pin_azi = 13;  //enable pin controls the motor speed with PWM
static int in1_azi = 14;      // logic input 1

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


//Vars for PI or P controller
float angleDSP,  //reference input
  error = 0,
  errorMargin = 0.01,
  direction = 0,
  currentPosition = 0,
  controllerGain = 1,
  controllerZero = 1,
  deltaVolt = 0,
  oldDeltaVolt = 0,
  aziOffset = 150,   // 70 - minimum voltage required for the azimut motor to run
  tiltOffset = 150;  // 95 - minimum voltage required for the tilt motor to run

bool clockwise = 0;

// State machine
enum operation { connect,
                 receiveAngle,  //setup
                 regulate,
                 move  //moisture, temp, humid
};
operation state = connect;

WiFiServer server(1234);  // TCP server on port 1234
WiFiClient client;

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

  switch (state) {
    case connect:
      // Wait for a client to connect
      client = server.available();
      if (client) {
        state = receiveAngle;
      } else {
        client.println("Give me an angle");
        delay(100);  //give time to send the message
        state = connect;
      }

      break;

    case receiveAngle:
      // angleDSP = inputDSP(); // for future code when DSP is working, get data from DSP
      readFromPC();
      if (angleDSP > 0) { //if we have received an angle
        client.print("Angle received: ");
        client.println(angleDSP);
        //initDirection();
        state = regulate;
      } else if (error > errorMargin && error < -errorMargin) {  //checks to see if it has breached our error margin, after essentially completion
        state = regulate;
      } else {
        currentPosition = convertPulsesToAngle();
        error = angleDSP - currentPosition;  // need to check if it has moved
        state = receiveAngle;
      }
      break;

    case regulate:
      regulator();

      if (error < errorMargin && error > -errorMargin) {  //need to check if it has overshot or not
        client.print("Error");
        client.print(error);
        client.println("Finished");
        analogWrite(ena_pin_azi, 0);  //stop the motor
        state = receiveAngle;
      } else {
        state = move;
      }
      break;

    case move:
      azimutVelocity();
      state = regulate;
      break;
  }
}


void readFromPC() {
  // temp test code
  String data = client.readStringUntil('\n');
  data.trim();  // Remove any extra spaces, \r, or \n characters
  // 2. Convert the string of characters into an integer number
  angleDSP = data.toInt();
  pos_azi = 0;  // reset waiting for new position
}



void regulator() {
  currentPosition = convertPulsesToAngle();
  error = angleDSP - currentPosition;
  client.print("Error: ");
  client.println(error);
  client.print("Current position: ");
  client.println(currentPosition);

  //p controller
  deltaVolt = error * controllerGain;
  //pi controller
  //deltaVolt = error * controllerGain - controllerZero * oldDeltaVolt;
  //oldDeltaVolt = deltaVolt;
}

void azimutVelocity() {
  float velocity = aziOffset + deltaVolt;
  if (deltaVolt < 0) {  // ensures the offset is inverted if the delta volt is negative
    velocity = -aziOffset + deltaVolt;
  } else {
    velocity = aziOffset + deltaVolt;
  }
  client.print("Velocity: ");
  client.println(velocity);
  //velocity can only range between 0 and 255
  if (velocity < 0) {
    velocity = velocity * (-1);  //if the motor overshoots and needs to go the other direction
    direction = !clockwise;      // change direction
    client.println("Direction change");
  } else {
    direction = clockwise;
  }
  if (velocity > 255) {  //capping so this is the max speed
    velocity = 255;
  }
  client.print("Velocity corrected: ");
  client.println(velocity);
  client.print("Direction: ");
  client.println(direction);
  digitalWrite(in1_azi, direction);    //control direction
  analogWrite(ena_pin_azi, velocity);  //control speed
}



float convertPulsesToAngle() {
  float position = ((float)pos_azi / 5000) * 360;  // current position converted to degrees
  client.print("Pos_azi");
  client.println(pos_azi);
  return position;
}






void inputDSP() {  //interface received from DSP
}

void sweep() {  //basic sweep
  //rotate towards a zero point
  while (rot_azi = 0) {
    analogWrite(ena_pin_azi, 70);
  }
  rot_azi = 0;
}


void initDirection() {
  if (angleDSP > 180) {
    direction = !clockwise;  //counter clock wise
    client.println("Counter wise");
  } else {
    direction = clockwise;  //clock wise
    client.println("Clockwise");
  }
}
