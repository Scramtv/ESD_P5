
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
static int btn_yellow = 42;
static int btn_blue = 41;

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

//Vars for button interrupt
volatile bool btn_yellow_interrupt = false;
volatile bool btn_blue_interrupt = false;

//safe variables
volatile float angleAzi = 0;  //input from PI or PC
volatile float angleTilt = 0;


//Vars for PI or P controller
float errorAzi = 0,
      errorTilt = 0,
      errorMargin = 0,
      currentPositionAzi = 0,
      currentPositionTilt = 0,
      controllerGainAzi = 24.83,  //from simulated model
  controllerGainTilt = 4.32,      // from simulated model
  deltaVoltAzi = 0,
      deltaVoltTilt = 0,
      aziOffset = 70,  // 70 - minimum voltage required for the azimut motor to run
  tiltOffset = 75;     // 75 - minimum voltage required for the tilt motor to run

bool clockwise = 0;
bool forward = 1;  //needs to be 1 always!!!!!!

// State machine
enum operation { connect,
                 receiveAngle,  //setup
                 regulate,
                 move  //moisture, temp, humid
};
operation state = connect;

WiFiServer server(1234);  // TCP server on port 1234
WiFiClient client;

TaskHandle_t core1;
TaskHandle_t core2;
SemaphoreHandle_t angleMutex;  //safe passing of variables


void setup() {
  pinSetup();

  init_serial();

  attachInt();

  init_wireless();

  xTaskCreatePinnedToCore(
    Core1Loop, /* Task function. */
    "Core1",   /* name of task. */
    10000,     /* Stack size of task */
    NULL,      /* parameter of the task */
    1,         /* priority of the task */
    &core1,    /* Task handle to keep track of created task */
    1);        /* pin task to core 0 */

  xTaskCreatePinnedToCore(
    Core2Loop,                           /* Task function. */
    "Core2",                             /* name of task. */
    10000,                               /* Stack size of task */
    NULL,                                /* parameter of the task */
    1,                                   /* priority of the task */
    &core2,                              /* Task handle to keep track of created task */
    0);                                  /* pin task to core 0 */
  angleMutex = xSemaphoreCreateMutex();  // Create the lock
  disableCore1WDT();
}

unsigned long lastrun = 0;
unsigned long interval = 10;



void Core1Loop(void* pvParameters) {
  while (true) {
    //vTaskDelay(1);
    switch (state) {
      case connect:
        // Wait for a client to connect
        client = server.available();
        if (client) {
          tiltHome();  //autohome
          client.println("Give me an angle");
          client.setTimeout(1);  // controls the timeout needed for ESP32 to read input from PuTTy
          state = receiveAngle;
        } else {
          state = connect;
        }

        break;

      case receiveAngle:
        {
          int azi;
          int tilt;
          
          if (xSemaphoreTake(angleMutex, portMAX_DELAY)) {
            azi = angleAzi;
            tilt = angleTilt;
            xSemaphoreGive(angleMutex);
          }

          //-----------------TILT CONTROL--------------------
          int gearing = 1;  // which gearing is running on the sensor
          currentPositionTilt = convertPulsesToAngle(pos_tilt, gearing);
          errorTilt = tilt - currentPositionTilt;



          //----------------AZIMUT CONTROL-------------------
          gearing = 5;  //switch gearing
          currentPositionAzi = convertPulsesToAngle(pos_azi, gearing);
          errorAzi = azi - currentPositionAzi;  // need to check if it has moved



          if ((errorAzi > errorMargin || errorAzi < -errorMargin) || (errorTilt > errorMargin || errorTilt < -errorMargin)) {  //checks to see if tilt or azimut has breached our error margin, after essentially completion
            state = regulate;
          } else {
            analogWrite(ena_pin_azi, 0);
            analogWrite(ena_pin_tilt, 0);
            state = receiveAngle;
          }
        }
        break;

      case regulate:
        deltaVoltTilt = errorTilt * controllerGainTilt;
        deltaVoltAzi = errorAzi * controllerGainAzi;
        state = move;
        break;

      case move:
        tiltVelocity();
        azimutVelocity();

        state = receiveAngle;
        break;
    }
  }
}

void Core2Loop(void* pvParameters) {
  while (true) {
    readFromPC();
    printData();


    vTaskDelay(5 / portTICK_PERIOD_MS);  // essential to ensure watchdog timer is not triggered
  }
}


float convertPulsesToAngle(float pos, int gearing) {
  float position = (pos / (gearing * 1000)) * 360;  // current position converted to degrees
  return position;
}

void sweep() {  //basic sweep
  //rotate towards a zero point
  while (rot_azi = 0) {
    analogWrite(ena_pin_azi, 70);
  }
  rot_azi = 0;
}


//never used
void loop() {}
