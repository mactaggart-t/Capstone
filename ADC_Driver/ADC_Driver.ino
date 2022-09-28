/*!
Linear Technology DC1491A Demonstration Board.
LTC2461: 16-Bit I2C Delta Sigma ADCs with 10ppm/C Max Precision Reference.

Linear Technology DC1493A Demonstration Board.
LTC2463: Differential, 16-Bit I2C Delta Sigma ADCs with 10ppm/C Max Precision Reference.

Linear Technology DC1266A Demonstration Board.
LTC2453: Differential, 16-Bit Delta Sigma ADC With I2C Interface

@verbatim

NOTES
  Setup:
   Set the terminal baud rate to 115200 and select the newline terminator. A voltage
   source (preferably low-noise) and a precision voltmeter are required. Ensure all
   jumpers on the demo board are installed in their default positions from the
   factory. Refer to Demo Manual DC1491A.
   * Run menu entry 4 if the voltage readings are not accurate. The DC1491A is not
     calibrated in the factory. Default values will be used until first customer
     calibration.
   If the voltage readings are in error, run menu entry 4 again. The previous
   calibration by the user may have been performed improperly.

  Menu Entry 1: Read ADC Voltage
   Ensure the applied voltage is within the analog input voltage range of 0V to
   +1.25V. Connect the voltage source between the DC1491A's IN terminal and GND
   terminal. This menu entry configures the LTC2461 to operate in 30 Hz mode.

  Menu Entry 2: Sleep Mode
   Enables sleep mode. Note that the REFOUT voltage will go to zero. Any
   subsequent read command will wake up the LTC2461.

  Menu Entry 3: 60 Hz Speed Mode
   Setup is the same as for Menu Entry 1, except the LTC2461 operates in 60 Hz mode,
   and continuous background offset calibration is not performed.

  Menu Entry 4: Calibration
   Follow the command cues to alternately enter voltages with VIN at GND and with
   VIN near full scale voltage, approximately 1.20V. Upon startup, the calibration
   values will be restored.

USER INPUT DATA FORMAT:
 decimal : 1024
 hex     : 0x400
 octal   : 02000  (leading 0 "zero")
 binary  : B10000000000
 float   : 1024.0

@endverbatim

http://www.linear.com/product/LTC2461
http://www.linear.com/product/LTC2463
http://www.linear.com/product/LTC2453

http://www.linear.com/product/LTC2461#demoboards
http://www.linear.com/product/LTC2463#demoboards
http://www.linear.com/product/LTC2453#demoboards


Copyright 2018(c) Analog Devices, Inc.

All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
 - Redistributions of source code must retain the above copyright
   notice, this list of conditions and the following disclaimer.
 - Redistributions in binary form must reproduce the above copyright
   notice, this list of conditions and the following disclaimer in
   the documentation and/or other materials provided with the
   distribution.
 - Neither the name of Analog Devices, Inc. nor the names of its
   contributors may be used to endorse or promote products derived
   from this software without specific prior written permission.
 - The use of this software may or may not infringe the patent rights
   of one or more patent holders.  This license does not release you
   from the requirement that you obtain separate licenses from these
   patent holders to use this software.
 - Use of the software either in source or binary form, must be run
   on or directly connected to an Analog Devices Inc. component.

THIS SOFTWARE IS PROVIDED BY ANALOG DEVICES "AS IS" AND ANY EXPRESS OR
IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, NON-INFRINGEMENT,
MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL ANALOG DEVICES BE LIABLE FOR ANY DIRECT, INDIRECT,
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
LIMITED TO, INTELLECTUAL PROPERTY RIGHTS, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

/*! @file
    @ingroup LTC2461
*/

#include <Arduino.h>
#include <Wire.h>
#include <string.h>
using namespace std;

// Function Declaration
//! Initialize Linduino


void setup()
{
  Wire.begin(); 
  Serial.begin(115200);         // Initialize the serial port to the PC

}

static float LTC2461_lsb = 1.907377E-05; 
static int32_t LTC2461_offset_code = 0;
int outputData = 0;
//! Repeats Linduino loop
void loop()  // ***** BEGIN MAIN CONTROL LOOP *****
{
//Wire.write(B0);
//Wire.beginTransmission(B0010100);
//Wire.write(B1);
//Wire.endTransmission();
uint16_t reading1 = 0;
uint16_t reading2 = 0;
float combined = 0;
int count = 0;
String voltage = "";
String current = "";
String temperature = "";
Wire.requestFrom(20, 2);
while(Wire.available()) {
        reading1=Wire.read();    // Receive a byte as character
        reading2=Wire.read();
        combined = (reading1<<8) | (reading2);
        //Serial.print(reading1, HEX);
        //Serial.println(reading2, HEX);         // Print the character
        //Serial.println(combined*LTC2461_lsb+0.000023,5);
        //Serial.println((combined*LTC2461_lsb+0.000023)*(12.8/1.25),3);
        // if(Serial.available())
        // {
        //     // Serial.println(Serial.read());
            
        // }
        if (outputData == 0) {
          voltage = String((combined*LTC2461_lsb+0.000023)*(12.8/1.25));
          voltage = "Voltage: " + voltage;
          Serial.write(voltage.c_str());
          outputData++;
        }
        else if (outputData == 1) {
          current = String("Current: ") + String("10.5");
          Serial.write(current.c_str());
          outputData++;
        }
        else {
          temperature = String("Temperature: ") + String("90.5");
          Serial.write(temperature.c_str());
          outputData = 0;
        }
        
 //reading = reading << 16;
 //reading |= Wire.read();
 //Serial.println(reading);

}

delay(1000);

}
