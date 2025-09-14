# Twinkle-Cam
A customizable LED Christmas lights project for the "Embedded Systems" exam at Univaq inspired by [Twinkly](https://twinkly.com/it/collections/christmas-lighting?srsltid=AfmBOoomoW6tOhAeTxNaT6c-f0Ry7cEBQX0MCbJsm1jus12nAZUUPlVf).
⚠️ The documentation, comments on the code and slides are in Italian.

## 📋 Table of Contents

- [Overview](#overview)
- [Requirements](#requirements)
- [Necessary Hardware](#necessary-hardware)
- [Key Features](#key-features)

## 🎯 Overview
This project allows users to freely place LED lights in 3D space and automatically detect their positions, enabling the display of dynamic color patterns (in particular diagonal, horizontal, and vertical bars with uniform colors).

## Hardware and Software Requirements 
- **Computer** – Runs the controller software written in [Processing](https://processing.org/), responsible for detecting and mapping the LED positions, as well as sending the desired colors and patterns to the Arduino.

- **Webcam** – Connected to the computer, used to detect and track the LEDs in 3D space.

- **Arduino Board (We used an Elegoo UNO)** – Handles low-level control of the LEDs, deciding which LEDs to turn on and their intensity at any given moment, based on the data received from the computer. It is connected to the computer to receive LED positions, colors, and pattern commands.

- **LED Strip** – We used WS2812B strip, connected to the Arduino board (pin 6).

## ⚡ Key Features

### The main idea
The workflow is that there is a initialization phase in which the Computer needs to detect the position of each leds. Thus we started from acquiring these information by turning on (once a time) the led and then, by seeing the maximum white pixel in the image, detecting the position. However this type 
Then, thanks to the digital twin





