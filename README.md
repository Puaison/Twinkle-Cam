# Twinkle-Cam

## 🎯 Overview
A customizable LED Christmas lights project for the "Embedded Systems" exam at Univaq inspired by [Twinkly](https://twinkly.com/it/collections/christmas-lighting?srsltid=AfmBOoomoW6tOhAeTxNaT6c-f0Ry7cEBQX0MCbJsm1jus12nAZUUPlVf).
This project allows users to freely place LED lights in 2D space and automatically detect their positions, enabling the display of dynamic color patterns (in particular diagonal, horizontal, and vertical bars with uniform colors).
⚠️ The documentation, comments on the code and slides are in Italian.

## 🖥️ Hardware and Software Requirements 
- **Computer** – Runs the controller software written in [Processing](https://processing.org/), responsible for detecting and mapping the LED positions, as well as sending the desired colors, velocity and patterns to the Arduino.

- **Webcam** – Connected to the computer, used to detect and track the LEDs in 2D space.

- **Arduino Board (We used an Elegoo UNO)** – Handles low-level control of the LEDs, deciding which LEDs to turn on and their intensity at any given moment, based on the data received from the computer. It is connected to the computer to receive LED positions, colors, velocity and pattern commands.

- **LED Strip** – We used WS2812B strip, connected to the Arduino board (pin 6).

## ⚡ Key Features

### Initialization
The initialization phase is required each time we change the disposition of the Strip. The goal is to create a map of the scene so that we can asssert where each singular LED is located in the scene and create its digital twin.
1) **Load and run `ChristmasTree.ino` on the Arduino.** Each LED will sequentially blink white for 1 second and then turn off, while the next LED lights up.
2) **Run `TwinkleCam.pde` on Computer** At this stage, a red dot appears on the real-time webcam image, marking the brightest pixel of the scene (ideally corresponding to the currently lit LED). However, reflections or noise can cause small artifacts, shifting the detected pixel away from the exact LED position.
    -  **Press `q`** → confirm the LED position if the red dot is close enough to the actual LED.
    -  **Press `w`** → skip the LED if the detection is unreliable (e.g., hidden or affected by artifacts). Its position will later be interpolated from surrounding LEDs.<br>
This process is repeated until all LEDs have been mapped.
3) **Press `e`** → generate the digital twin of the LED map, shown on the computer screen.
4) **Press `r`** → send the detected LED coordinates (x/y) via the serial port to the Arduino and wait for the upload to complete.

### Running program
Once the mapping information is fully sent to the Arduino:
- All LEDs will light up simultaneously.
- Using the digital twin, you can interactively select two colors for interpolation, set the blinking speed, and define the pattern direction.
- Simply **click and drag with the left mouse button** in the desired direction to apply the pattern.





