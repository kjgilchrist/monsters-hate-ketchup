#include <Bounce2.h>
#include <Wire.h>


/*
Potentiometer Code:
GND - Signal - VCC, Note: GND and VCC are interchangable
Created by ArduinoGetStarted.com, Public Domain
Tutorial page: https://arduinogetstarted.com/tutorials/arduino-potentiometer

FSR Code:
Connect one end of FSR to 5V, the other end to Analog 0.
Then connect one end of a 10K resistor from Analog 0 to ground
For more information see www.ladyada.net/learn/sensors/fsr.html
*/
/*
 * Teensy-LC Analog Pins
 * A0 - 14 - White - Button
 * A1 - 15 - Yellow - Potentiometer
 * A2 - 16 - Green - Acc/Gyro (Not Used)
 * A3 - 17 - Blue - Acc/Gryo (Not Used)
 * A4 - 18 - Black - FSR
 */
 
const int butAnalogPin = A0;
const int potAnalogPin = A1;
const int fsrAnalogPin = A4;
int prevButtonState = 0;
int prevPotValue = 0;
int prevFsrReading = 0;

void setup() {
  // Debugging via Serial Monitor
  Serial.begin(9600);
  Serial.println("Serial Begin");
}


void loop() {
  // Read Analog Inputs from all sensors.
  int buttonState = analogRead(butAnalogPin);
  int potValue = analogRead(potAnalogPin);
  int fsrReading = analogRead(fsrAnalogPin);
  // Map potentiometer's voltage (from 0V to 5V):
  float voltage = floatMap(potValue, 0, 1023, 0, 3.3);

  // Serial.print("FSR Analog: ");
  // Keyboard.println(fsrReading);
  
  // Print current state of each sensor.
  if (fsrReading < prevFsrReading && fsrReading < 750) {
    // Serial.print("FSR Analog: ");
    // Serial.println(fsrReading);
    Keyboard.print("l");
  }
  if (potValue < 300) {
    // Serial.println("Go Left");
    Keyboard.print("d");
  } else if (potValue > 723) {
    // Serial.println("Go Right"
    Keyboard.print("a");
  } else {}
  if (buttonState == 1) {
    // Serial.println("Flash");
    Keyboard.print("f");
  }

  // Serial.println("");
  // Set current to previous for next loop.
  prevButtonState = buttonState;
  prevPotValue = potValue;
  prevFsrReading = fsrReading;
  // delay(1000);
}

float floatMap(float x, float in_min, float in_max, float out_min, float out_max) {
  return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min;
}
