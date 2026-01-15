float tiltInDegrees = 0;
float aziInDegrees = 0;
float angleAzi = 0;
float angleTilt = 0;

//encoder_Azimut pins
static int pinA_azi = 38;  //Pin A
static int pinB_azi = 40;  //Pin B
static int pinZ_azi = 37;  //Pin Z

//Motor_Azimut pins:
static int ena_pin_azi = 13;  //enable pin controls the motor speed with PWM
static int dir_azi = 14;      // logic input 1

//encoder_tilt pins
static int pinA_tilt = 26;  //Pin A
static int pinB_tilt = 33;  //Pin B
static int pinZ_tilt = 21;  //Pin Z

//Encoder_tilt_motor pins
static int pinA_tilt_motor = 20;  //Pin A

//Motor_tilt pins:
static int ena_pin_tilt = 16;  //enable pin controls the motor speed with PWM
static int dir1_tilt = 18;     // logic input 1
static int dir2_tilt = 17;     //logic input 2

//btn
static int btn_yellow = 42;
static int btn_blue = 41;

//-------------------------------------------------------------------------------//
#include "soc/gpio_struct.h"
#include "driver/gpio.h"
//#include <WiFi.h>
#include "esp_timer.h"  //used for setting a specific sampling rate
// Fast read
#define READ_PIN(pin) ((pin) < 32 ? ((GPIO.in >> (pin)) & 1) : ((GPIO.in1.val >> ((pin)-32)) & 1))

//Vars for encoder azimut
volatile int pos_azi = 0;
volatile int rot_azi = 0;

//Vars for encoder tilt
volatile int pos_tilt = 0;
volatile int rot_tilt = 0;

//Vars for button interrupt
//Needs to be used for emergency braking
volatile bool yellow_interrupt = false;
volatile bool blue_interrupt = false;

//variables for intercore communication
volatile float targetAzi = 0;  //input angle from PI or PC
volatile float targetTilt = 0;
volatile float currentAzi = 0;
volatile float currentTilt = 0;

//Vars for P controller
static float controllerGainAzi = 24.83;  //from simulated model
static float controllerGainTilt = 4.32;  // from simulated model
static int aziOffset = 110;              // 110 - minimum voltage required for the azimut motor to run
static int tiltOffset = 300;              // 300 - minimum voltage required for the tilt motor to run
static int sampleRate = 200;              // sample rate in micros seconds
//------------------MAX 150 micros seconds right now!!!!!!!

//WiFiServer server(1234);  // TCP server on port 1234
//WiFiClient client;

//setting up 2 cores to run in parallel (FreeRTOS)
TaskHandle_t core1;
TaskHandle_t core2;
SemaphoreHandle_t targetAngleMutex;   //for safe passing of variables between the two cores
SemaphoreHandle_t currentAngleMutex;  //for safe passing of variables between the two cores

void setup() {

  pinSetup();

  init_serial();

  attachInt();

  targetAngleMutex = xSemaphoreCreateMutex();   // Create the lock for target angle
  currentAngleMutex = xSemaphoreCreateMutex();  // Create the lock for current angle



  xTaskCreatePinnedToCore(
    Core1Loop,      /* Task function. */
    "16384 Loop", /* name of task. */
    16384,          /* Stack size of task */
    NULL,           /* parameter of the task */
    3,              /* priority of the task */
    &core1,         /* Task handle to keep track of created task */
    1);             /* pin task to core 0 */

  xTaskCreatePinnedToCore(
    Core2Loop,            /* Task function. */
    "Communication Loop", /* name of task. */
    16384,                /* Stack size of task */
    NULL,                 /* parameter of the task */
    1,                    /* priority of the task */
    &core2,               /* Task handle to keep track of created task */
    0);                   /* pin task to core 0 */

  disableCore1WDT();  //Disables watchdog on core1 as maintance is handled by core 0

  tiltHome();  // We need to home before the timer starts, form there everything is automatic

  init_sample_rate_timer();  //start sample rate timer
}


void Core1Loop(void* pvParameters) {

  while (true) {
    ulTaskNotifyTake(pdTRUE, portMAX_DELAY);  // Sleep until timer pulses
    controlCode();                            // Runs on Core 1
  }
}


void Core2Loop(void* pvParameters) {
  while (true) {
    vTaskDelay(5 / portTICK_PERIOD_MS);  // essential to ensure watchdog timer is not triggered
    get_serial_cmd();
    send_serial_pos();
  }
}

float convertPulsesToAngle(float pos, int gearing) {
  float position = (pos / (gearing * 1000)) * 360;  // current position converted to degrees
  return position;
}

//never used
void loop() {}
