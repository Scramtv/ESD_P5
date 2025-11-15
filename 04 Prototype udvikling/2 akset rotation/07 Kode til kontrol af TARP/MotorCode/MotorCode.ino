/*
Ting der skal nåes:
Fast sample rate
Serial comms

Nice:
Kommentarer
Optimer kode, så loop1 er (kører hver x'ende sekund):
- Opdater mål grader
- opdater error
- Bevæg
Loop2 (fast opdatering):
- Opdater mål grader fra PC
- Send nuværende pos
*/


//encoder_Azimut pins
static int pinA_azi = 38;  //Pin A
static int pinB_azi = 40;  //Pin B
static int pinZ_azi = 37;  //Pin Z

//Motor_Azimut pins:
static int ena_pin_azi = 13;  //enable pin controls the motor speed with PWM
static int in1_azi = 14;      // logic input 1 //H123 kald denne direction

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

//Vars for button interrupt
volatile bool btn_yellow_interrupt = false; //H123 No no no, du kalder ikke en var et interrupt
volatile bool btn_blue_interrupt = false; //H123 Ovenstående igen
//H123 Igen grund til at være interrupts
//H123 Interrupts skal forhindre mere bevægelse samme retning

//variables for intercore communication
volatile float angleAzi = 0;  //input from PI or PC
volatile float angleTilt = 0; //H123 Overvej at kalde denne target angle e.l. for at gøre det mere tydeligt hvad den bruges til. Gælder også angleAzi. NB mellemvariable


//Vars for PI or P controller
float errorAzi = 0,
      errorTilt = 0,
      errorMargin = 0, //H123 Overvej at slet - ja
      currentPositionAzi = 0, //H123 Hvad er forskellen på denne og pos_tilt? Antageligt noget med at denne er i grader, men det står ikke tydeligt i variablen. (korrekt)
      currentPositionTilt = 0, //H123 Ovenstående
      controllerGainAzi = 24.83,  //from simulated model
      controllerGainTilt = 4.32,      // from simulated model
      deltaVoltAzi = 0,
      deltaVoltTilt = 0,
      aziOffset = 130,  // 130 - minimum voltage required for the azimut motor to run
      tiltOffset = 75;     // 75 - minimum voltage required for the tilt motor to run

//H123 Offets og gains er konstanter og bør defineres som dette, for at lade compileren optimere

bool clockwise = 0;
bool forward = 1;  //needs to be 1 always!!!!!!
//H123 The fuck er ovenstående til, hvis den altid skal være 1??
//Ja fix

// State machine
enum operation { connect,
                 receiveAngle,  //setup
                 regulate,
                 move 
};
operation state = connect;

WiFiServer server(1234);  // TCP server on port 1234
WiFiClient client;

TaskHandle_t core1;
TaskHandle_t core2;
SemaphoreHandle_t angleMutex;  //for safe passing of variables between the two cores


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
  disableCore1WDT(); //Disables watchdog on core1 as maintance is handled by core 0
}


void Core1Loop(void* pvParameters) {
  while (true) {
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
          int azi; //H123 giv et bedre navn til disse to variabler
          int tilt;
          
          //Converting volitile variables to non-volitile
          if (xSemaphoreTake(angleMutex, portMAX_DELAY)) {
            azi = angleAzi;
            tilt = angleTilt;
            xSemaphoreGive(angleMutex);
          }
          //H123 Hvad sker der, hvis vi ikke kan tage semaphoren? Så bruger vi ukendt data.
          //Korrekt


          //-----------------TILT CONTROL--------------------
          int gearing = 1;  // which gearing is running on the sensor
          currentPositionTilt = convertPulsesToAngle(pos_tilt, gearing);
          errorTilt = tilt - currentPositionTilt;



          //----------------AZIMUT CONTROL-------------------
          gearing = 5;  //gearing on sensor for azimuth
          currentPositionAzi = convertPulsesToAngle(pos_azi, gearing);
          errorAzi = azi - currentPositionAzi;  //calculate error

          //H123 Hvorfor er de to gearinger her ikke konstanter?

          //H123 Fremover kunne du jo bruge abs() i stedet for dette, men fred være med det. Jeg er igen tilhænger af at fjerne errorMargin YEET
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

//never used
void loop() {}
