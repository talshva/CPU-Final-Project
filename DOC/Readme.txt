♦ VHDL Project Overview ♦
The project consists of the following components:
#############################################################################################################################
-----------------------------------------------------------------------------------------------------------------------------
File 1: QuartusTop.vhd
The QuartusTop file serves as the top-level entity that integrates all the components together to create a complete system.
It connects the MCU to external Pinout, and handles port mapping to interface with the DE10 Altera board and other peripherals.
-----------------------------------------------------------------------------------------------------------------------------
File 2: MCU.vhd
The MCU (Microcontroller Unit) module represents the heart of the pipelined MIPS CPU.
It integrates the core MIPS processor with all the additional components, such as the Basic Timer, GPIO, and the Interrupt Controller.
The MCU acts as the central processing unit for the whole system and is responsible for executing instructions, handling interrupts,
and managing data flow between different components.
-----------------------------------------------------------------------------------------------------------------------------
File 3: GPIO.vhd
The GPIO (General Purpose Input/Output) module represents a configurable digital I/O interface in the pipelined MIPS CPU.
It allows the MCU to communicate with external devices using GPIO pins.
The GPIO module can be configured to act as either input or output, for example HEX displays, LEDs and Switches.
-----------------------------------------------------------------------------------------------------------------------------
File 4: BasicTimer.vhd
This file represents the Basic Timer component that will be added to the pipelined MIPS CPU.
The Basic Timer is a hardware timer used to generate precise time intervals.
It can be used for various purposes, such as generating periodic interrupts and external PWM from the MCU.
-----------------------------------------------------------------------------------------------------------------------------
File 5: InterruptController.vhd
This file contains the implementation of the Interrupt Controller component.
The Interrupt Controller is responsible for managing and prioritizing interrupts in the pipelined MIPS CPU.
It can handle multiple interrupt sources, allowing the MCU to respond to time-critical events and perform the relevant ISR.
-----------------------------------------------------------------------------------------------------------------------------
File 6: UART.vhd
This file contains the implementation of the UART (Universal Asynchronous Receiver/Transmitter) module.
UART is a standard for serial communication between devices and is commonly used for communication with external devices like 
computers, sensors, or other embedded systems.
The UART module enables bidirectional serial communication through a designated set of pins.
-----------------------------------------------------------------------------------------------------------------------------
File 7: PipelinedMIPS.vhd
This file represents the top-level entity that wraps all the individual components together to create a pipelined MIPS CPU.
It connects the components and orchestrates the flow of instructions through the pipeline.
-----------------------------------------------------------------------------------------------------------------------------
File 8: IFETCH.vhd
This file implements the instruction fetch stage of the MIPS pipeline CPU.
It is responsible for fetching instructions from memory.
-----------------------------------------------------------------------------------------------------------------------------
File 9: IDECODE.vhd
This file implements the instruction decode stage of the MIPS pipeline CPU.
It decodes the fetched instructions and extracts relevant information such as opcode, register numbers, and immediate values.
-----------------------------------------------------------------------------------------------------------------------------
File 10: EXECUTE.vhd
This file implements the execute stage of the MIPS pipeline CPU.
It performs arithmetic and logical operations based on the decoded instructions.
-----------------------------------------------------------------------------------------------------------------------------
File 11: DMEMORY.vhd
This file represents the data memory component of the MIPS pipeline CPU.
It handles read and write operations to the data memory.
-----------------------------------------------------------------------------------------------------------------------------
File 12: CONTROL.vhd
This file contains the control unit for the MIPS pipeline CPU.
It generates control signals based on the opcode of the instruction being executed.
-----------------------------------------------------------------------------------------------------------------------------
File 13: Forwarding.vhd
This file implements the forwarding unit in the MIPS pipeline CPU.
It detects data hazards and resolves them by forwarding the required data to the stages that need it.
-----------------------------------------------------------------------------------------------------------------------------
File 14: HazardDetection.vhd
This file implements the hazard detection unit in the MIPS pipeline CPU.
It detects and handles hazards such as data hazards and control hazards to ensure correct execution of instructions.
-----------------------------------------------------------------------------------------------------------------------------
File 15: BidirPin.vhd
The BidirPin file contains the implementation of a bi-directional pin module.
In FPGA designs, bidirectional pins are used to enable communication between the internal logic (MCU) and external devices. 
This module allows the MCU to read and write data from/to external peripherals.
-----------------------------------------------------------------------------------------------------------------------------
File 16: Binary2Hex.vhd
Contains the implementation of a module that transfers an 8-bit binary value into a format suitable for driving a 7-segment display.
-----------------------------------------------------------------------------------------------------------------------------
File 17: Aux_Package.vhd
The Aux_Package file serves as a package that encapsulates all the components required for the enhanced pipelined MIPS CPU. 
-----------------------------------------------------------------------------------------------------------------------------

♥ Note: Please refer to the respective component files for detailed implementations of the processes and functionalities. ♥