# Pipelined MIPS CPU VHDL Project

## Overview
This project presents the implementation of a Pipelined MIPS CPU with 5 stages, specifically designed and tested for the Altera DE10 FPGA board. The CPU is designed using VHDL and integrates core MIPS features along with GPIO, Basic Timer, and Interrupt Controller.
Final GUI with uart demonstration video:
https://github.com/talshva/CPU-Final-Project/assets/82408347/68e29369-88cc-459a-90d7-bffb370d257c

## Table of Contents
1. [Project Goals and System Overview](#project-goals-and-system-overview)
2. [Functional Verification](#functional-verification)
3. [GPIO Implementation](#gpio-implementation)
4. [Interrupt Controller](#interrupt-controller)
5. [Basic Timer Module](#basic-timer-module)
6. [UART Communication](#uart-communication)

## Project Goals and System Overview
The project aimed to implement a processor with a MIPS core supporting memory mapping, external interrupts, and interrupt handling routines. The core supports identification and handling of data dependencies using Forwarding Unit and Hazard Detection, optimized for execution on the Altera FPGA DE10 board.

### System Architecture
The architecture integrates multiple modules encapsulated within the MCU, which are detailed below.

## Functional Verification
To ensure correctness, a functional verification process was undertaken using assembly language programs that perform various operations, including matrix addition, tested via simulation tools like Modelsim and Signal Tap.

## GPIO Implementation
The General-Purpose Input/Output interface allows the CPU to interact with external devices such as LEDs and switches, configured as either input or output.

## Interrupt Controller
This module handles the prioritization and management of external interrupts, allowing the CPU to respond to events and execute relevant ISRs (Interrupt Service Routines).

## Basic Timer Module
A hardware timer component that generates precise time intervals for various functions, including periodic interrupts and PWM signal generation.

## UART Communication
Implements a UART interface for serial communication, essential for interactions with external devices like computers, sensors, or other embedded systems.

## Compilation and Configuration
The project files include configuration settings for the FPGA board, detailing pin assignments and system constraints necessary for the correct operation of the CPU.

## Project Components
1. `QuartusTop.vhd` - Top-level entity for system integration.
2. `MCU.vhd` - The microcontroller unit acting as the CPU core.
3. `GPIO.vhd` - Module for digital I/O interface.
4. `BasicTimer.vhd` - Component for hardware timing functions.
5. `InterruptController.vhd` - Manages prioritization and handling of interrupts.
6. `UART.vhd` - For serial communication.
7. `PipelinedMIPS.vhd` - Top entity that orchestrates instruction flow.
8. `IFETCH.vhd` - Instruction fetch stage.
9. `IDECODE.vhd` - Instruction decode stage.
10. `EXECUTE.vhd` - Execution stage of the pipeline.
11. `DMEMORY.vhd` - Data memory access.
12. `CONTROL.vhd` - Control unit for the MIPS CPU.
13. `Forwarding.vhd` - Handles data hazards.
14. `HazardDetection.vhd` - Manages data and control hazards.
15. `BidirPin.vhd` - Bi-directional pin module for interfacing with peripherals.
16. `Binary2Hex.vhd` - Converts binary value for a 7-segment display.
17. `Aux_Package.vhd` - Encapsulates components for the MIPS CPU.

## Additional Materials
- Simulation waveforms and Signal Tap logs demonstrating functional tests.
- Videos in the project directory showcase the CPU's operation on the FPGA board.




## Note
For a more comprehensive understanding of the processes and functionalities, please refer to the individual component files, or this detailed pdf:
[CPU Final Project.pdf](https://github.com/talshva/CPU-Final-Project/files/15001328/CPU.Final.Project.pdf)
