Title: Artificial Horizon/Attitude Indicator Widget "AttInd"
Author: Shane Christopherson
Date: 2026-05-29
Version: 1.2.0

Source: https://github.com/qsiguy/EdgeTX-Widgets
https://www.youtube.com/@shanesdiy

Copyright (C): Shane Christopherson/Shane's DIY

License GPLv2: http://www.gnu.org/licenses/gpl-2.0.html

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License version 2 as
published by the Free Software Foundation.

This program is distributed in the hope that it will be useful
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

Put in /WIDGETS/AttInd/

Requires pitch and roll telemetry value from receivers such as the
HelloRadio HR7EG, HR8EG, and other DIY ELRS gyro receivers like the BetaFPV SuperP, using the
MPU6050 or LSM6DXX IMU (Inertial Measurement Unit) *Does NOT work with Spektrum DSMX gyro receivers.

<img width="480" height="272" alt="Half Screen Widget" src="https://github.com/user-attachments/assets/bd9441aa-586f-47fa-94e4-1e8504633b78" />

<img width="480" height="272" alt="Large screen widget" src="https://github.com/user-attachments/assets/42bf55cc-b941-44ac-b78c-853fc4d14077" />

<img width="480" height="272" alt="Full screen widget" src="https://github.com/user-attachments/assets/be8575e0-2f77-41d9-bff6-c3fe2bfe0b73" />
  
Telemetry ratio must be set to high speed. If using 100Hz
packet rate you must have telem ratio 1:4 (min) or 1:2. If using
333Hz you must use 1:16 (min), 1:8, 1:4, or 1:2.  Slower ratio and
the data is too slow for linear response and the widget will lag.

Minimum Telemetry Ratio Settings

<img width="480" height="272" alt="100Hz_1 4 telemetry" src="https://github.com/user-attachments/assets/8207d3e7-8d5e-4bf7-990a-98fefd09bd90" />

<img width="480" height="272" alt="333Hz_1 16 telemetry" src="https://github.com/user-attachments/assets/80126713-919d-4dec-b00f-4022783c5f0b" />

**Telemetry values for "Ptch" and "Roll" default to "rad" units and must be set to ' ° ' (degree) for the Widget to work**

<img width="480" height="272" alt="Telemetry edit 01" src="https://github.com/user-attachments/assets/a91b3550-712f-417d-aa51-8d01e989adce" />

<img width="480" height="272" alt="Telemetry edit 02" src="https://github.com/user-attachments/assets/a3a74ea0-1350-4230-85ea-67d9a2d01f8b" />

<img width="480" height="272" alt="Telemetry edit 03" src="https://github.com/user-attachments/assets/54cff2e7-12c8-4e35-b8fc-ed942d7077fa" />

<img width="480" height="272" alt="Telemetry edit 04" src="https://github.com/user-attachments/assets/1036388f-eeb8-4468-8957-126b5e5691c4" />

<img width="480" height="272" alt="Telemetry edit 05" src="https://github.com/user-attachments/assets/9262684f-0f24-49ea-8654-4667ad326073" />

Pitch telemetry value must be named "Ptch" and roll must be named
"Roll". Telemetry value can be renamed in the radio telemetry list
or if another name is desired, edit lines 244 & 245 with your actual
pitch and roll telemetry names.

NOTE: AttInd will display the current flight mode from telemetry value "FM" centered at
the top of the display although it has been intentionally disabled by commenting out the
relevant code lines as it "clutters" the instrument. If you wish to enable it, un-comment
lines 364 -> 369 and ensure your flight mode telemetry value is named "FM".

