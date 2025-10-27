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

  pinMode(46, OUTPUT);
  digitalWrite(46,0);
}

unsigned long lastrun = 0;
unsigned long interval = 10;



void loop() {
  WiFiClient client = server.available();

  // Wait for a client to connect
  if (client) {
    // If client is connected, send data
    client.println("Hello PC! ESP32 AP connected.");
    Serial.println("Connected to PC");
    minVoltageTest(client);
  }
}


void tiltVelocityTest(WiFiClient client) {
  // VELOCITY TEST TILT MOTOR
  digitalWrite(ena_pin_tilt, 1);
  digitalWrite(in1_tilt, 1);
  lastrun = millis();
  while (true) {
    if (millis() - lastrun > interval) {
      lastrun += interval;
      client.print(millis());
      client.print(";");
      client.print(pos_tilt);
      client.print(";");
      client.print(rot_tilt);
      client.println(";");
    }
=======
    // VELOCITY TEST AZIMUT MOTOR
 client.println("Hello PC! ESP32 AP connected.");
    digitalWrite(46, 1);
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


    // VELOCITY TEST TILT MOTOR



    //digitalWrite(ena_pin_tilt, 1);
    //digitalWrite(in1_tilt, 1);
    //lastrun = millis();
    //while (true) {
    //  if (millis() - lastrun > interval) {
    //    lastrun += interval;
    //    client.print(millis());
    //    client.print(";");
    //    client.print(pos_tilt);
    //    client.print(";");
    //    client.print(rot_tilt);
    //    client.println(";");
    //  }
    //}
>>>>>>> Stashed changes
  }
}

void azimutVelocityTest(WiFiClient client) {
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

void minVoltageTest(WiFiClient client) {
  while (true) {
    // 1. Read all characters until a newline is found
    String data = client.readStringUntil('\n');
    data.trim();  // Remove any extra spaces, \r, or \n characters

    // 2. Convert the string of characters into an integer number
    int pwmValue = data.toInt();

    if (pwmValue > 0 && pwmValue < 255) {
      client.print("Received: ");
      client.println(pwmValue);
      analogWrite(ena_pin_tilt, pwmValue);
      digitalWrite(in1_tilt, 1);

      float temp = (float)pwmValue * 12 / 255;
      client.print("Voltage set to: ");
      client.println(temp);
    }
  }
}