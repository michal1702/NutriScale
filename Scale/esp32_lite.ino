#include <Adafruit_ST7735.h>
#include <Adafruit_GFX.h>
#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>
#include "HX711.h"
#include <SPI.h>

#define SERVICE_UUID "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
#define CHARACTERISTIC_UUID "beb5483e-36e1-4688-b7f5-ea07361b26a8"

#define TFT_LEDA 12
#define TFT_CS 14
#define TFT_RES 26
#define TFT_RS 27
#define TFT_SCK 33
#define TFT_SDA 25

#define UNITS_BTN 5
#define TARE_BTN 16

#define LOADCELL_DOUT_PIN 2
#define LOADCELL_SCK_PIN 4

#define BT_LED 15

BLEServer *pServer = NULL;
BLECharacteristic *pCharacteristic = NULL;
bool deviceConnected = false;
bool oldDeviceConnected = false;
float value = 0.0f;
float tareValue = 0.0f;
float ozValue = 0.0f;
float lastValue = 0.0f;

bool tareSet = false;

uint8_t unitsButtonPrev;
uint8_t tareButtonPrev;

float fullWeight;

unsigned int measurement = 0;

unsigned long lastTime = 0;
const unsigned long timerDelay = 5;

unsigned long screenLastTime = 0;
const unsigned long screenTimerDelay = 50000;

HX711 loadcell; // define load cell

bool grams = true;

Adafruit_ST7735 tft = Adafruit_ST7735(TFT_CS, TFT_RS, TFT_SDA, TFT_SCK, TFT_RES); //define lcd

class MyServerCallbacks : public BLEServerCallbacks
{
    void onConnect(BLEServer *pServer)
    {
      deviceConnected = true;
    };

    void onDisconnect(BLEServer *pServer)
    {
      deviceConnected = false;
    }
};

void setup()
{
  // initialize buttons
  pinMode(UNITS_BTN, INPUT_PULLUP);
  unitsButtonPrev = digitalRead(UNITS_BTN);
  pinMode(TARE_BTN, INPUT_PULLUP);
  tareButtonPrev = digitalRead(UNITS_BTN);

  // initialize output diode and lcd background
  pinMode(BT_LED, OUTPUT);
  digitalWrite(BT_LED, LOW);
  pinMode(TFT_LEDA, OUTPUT);
  digitalWrite(TFT_LEDA, HIGH);

  // initialize a ST7735S lcd screen
  tft.initR(INITR_BLACKTAB);
  tft.setRotation(1);
  tft.fillScreen(ST7735_BLACK);

  Serial.begin(115200);

  loadcell.begin(LOADCELL_DOUT_PIN, LOADCELL_SCK_PIN);
  handleScaleCalibration();

  handleBluetoothSetUp();
}

void loop()
{
  // handle units button
  if (digitalRead(UNITS_BTN) == LOW && unitsButtonPrev == HIGH)
  {
    grams = !grams;
  }

  //handle tare button
  if (digitalRead(TARE_BTN) == LOW && tareButtonPrev == HIGH)
  {
    tareValue = fullWeight;
    tareSet = true;
  }

  char btString[10]; // char array to be sent to mobile device

  displayScaleReadings();

  /**
     If value is greater than max value (5000g) send max value.
     If value is lower than 0 send 0.
     If none of above send exact reading value.
  */
  if (value > 5000.0f)
  {
    dtostrf(5000.0f, 1, 0, btString);
  }
  else if (value <= 0.0f)
  {
    dtostrf(0.0f, 1, 0, btString);
  }
  else
  {
    dtostrf(value, 1, 0, btString);
  }

  fullWeight = getScaleValue();

  // Turns off screen backlight after inactivity and turns it on after putting some weight on scale.
  if ((millis() - screenLastTime) > screenTimerDelay)
  {
    digitalWrite(TFT_LEDA, LOW);
    screenLastTime = millis();
  }

  if (abs(value - lastValue) > 1.5f)
  {
    digitalWrite(TFT_LEDA, HIGH);
  }

  // Apply tare negative value after all weight is put off
  if (measurement >= 1)
  {
    lastValue = value;
    value = fullWeight - tareValue;
  }
  else
  {
    measurement++;
    value = 0.0;
  }

  handleBluetooth(btString);
}

void handleScaleCalibration()
{
  tft.setTextColor(ST7735_WHITE, ST7735_BLACK);
  tft.setTextSize(2);
  tft.setCursor(10, 45);
  tft.print("Calibration");
  delay(4000);
  tft.fillScreen(ST7735_BLACK);
  tft.setCursor(15, 15);
  tft.print("Remove all");
  tft.setCursor(15, 40);
  tft.print("weight from");
  tft.setCursor(45, 60);
  tft.print("scale");
  delay(5000);
  loadcell.tare();
  tft.fillScreen(ST7735_BLACK);
}

void handleBluetoothSetUp()
{
  // Create the BLE Device
  BLEDevice::init("ESP32_Scale");

  // Create the BLE Server
  pServer = BLEDevice::createServer();
  pServer->setCallbacks(new MyServerCallbacks());

  // Create the BLE Service
  BLEService *pService = pServer->createService(SERVICE_UUID);

  // Create a BLE Characteristic
  pCharacteristic = pService->createCharacteristic(
                      CHARACTERISTIC_UUID,
                      BLECharacteristic::PROPERTY_READ |
                      BLECharacteristic::PROPERTY_WRITE |
                      BLECharacteristic::PROPERTY_NOTIFY |
                      BLECharacteristic::PROPERTY_INDICATE);

  // Create a BLE Descriptor
  pCharacteristic->addDescriptor(new BLE2902());

  // Start the service
  pService->start();

  // Start advertising
  BLEAdvertising *pAdvertising = BLEDevice::getAdvertising();
  pAdvertising->addServiceUUID(SERVICE_UUID);
  pAdvertising->setScanResponse(false);
  pAdvertising->setMinPreferred(0x0);
  BLEDevice::startAdvertising();
  Serial.println("Waiting a client connection to notify...");
}

/**
   @brief Function reads values from both load cells and returns result

   @return float
*/
float getScaleValue()
{
  float weightA;
  float weightB;
  loadcell.set_scale(132.369);
  loadcell.set_gain(128);
  Serial.print("Weight A: ");
  weightA = loadcell.get_units() + 1530.205;
  Serial.println(weightA);

  loadcell.set_scale(463.736);
  loadcell.set_gain(32);
  Serial.print("Weight B: ");
  weightB = loadcell.get_units() - 48.3424;
  Serial.println(weightB);
  Serial.print("Weight A+B: ");
  Serial.println(weightA + weightB);
  return weightA + weightB;
}

void displayScaleReadings()
{
  if (value > 5000.0f)
  {
    tft.setTextColor(ST7735_WHITE, ST7735_BLACK);
    tft.setTextSize(2);
    tft.setCursor(10, 70);
    tft.print("Overweight!!");
  }
  else
  {
    tft.setTextColor(ST7735_WHITE, ST7735_BLACK);
    tft.setTextSize(3);
    tft.setCursor(26, 16);
    tft.print("Weight:");
    char string[10];
    char weightContent[13];
    tft.setTextSize(2);
    tft.fillRect(10, 70, 150, 20, ST7735_BLACK);
    if (grams)
    {
      if (value < 1000)
        tft.setCursor(50, 70);
      else
        tft.setCursor(40, 70);
      dtostrf(value, 1, 0, string);
      strcpy(weightContent, string);
      strcat(weightContent, "g");
    }
    else
    {
      if (value < 1000)
        tft.setCursor(35, 70);
      else
        tft.setCursor(30, 70);
      dtostrf(value * 0.0352, 1, 3, string);
      strcpy(weightContent, string);
      strcat(weightContent, "oz");
    }
    tft.print(weightContent);
  }
}

void handleBluetooth(char btString[])
{
  // notify changed value
  if (deviceConnected)
  {
    digitalWrite(BT_LED, HIGH);
    if ((millis() - lastTime) > timerDelay)
    {
      pCharacteristic->setValue(btString);
      pCharacteristic->notify();
      lastTime = millis();
    }
  }
  else
  {
    digitalWrite(BT_LED, LOW);
  }
  // disconnecting
  if (!deviceConnected && oldDeviceConnected)
  {
    delay(500);
    pServer->startAdvertising(); // restart advertising
    Serial.println("start advertising");
    oldDeviceConnected = deviceConnected;
  }
  // connecting
  if (deviceConnected && !oldDeviceConnected)
  {
    oldDeviceConnected = deviceConnected;
  }
}
