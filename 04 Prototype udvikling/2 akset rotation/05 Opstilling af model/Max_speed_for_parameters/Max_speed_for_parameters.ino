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
    // If client is connected, send data
    client.println("Hello PC! ESP32 AP connected.");
    digitalWrite(ena_pin_azi, 1);
    digitalWrite(in1_azi, 1);
    lastrun = millis();
    while (true) {
      if (millis() - lastrun > interval) {
        lastrun += interval;
        client.print(millis());
        client.print(";");
        client.print(pos_azi);
        client.print(";");
        client.print(rot_azi);
        client.println(";");
      }
    }
  }
}
