# CPLD Design Files for MSCP Emulator

The MSCP Emulator, a Q-Bus card for PDP-11, uses two CPLDs. One ATF1508 and one ATF1504. 
To program the CPLDs you can use the JEDEC files or use the design files and compile them
yourself using  WinCUPL II from Microchip.

There exist two versions of the MSCP Emulator, one for the real Q-Bus and one for
my own QBUS64, a DIN41612 version, of the Q-Bus used for my own PDP-11/Hack.

This repository contains the CPLD design files for both version of the MSCP Emulator
hardware. 

The difference between the Q-Bus and the QBUS64 version is only on the bus side.
The register interface and control signals for the microcontroller are identical
and allows to run exactly the same microcontroller firmware on both versions.

## QBUSEMUMAIN.PLD

This is the master CPLD. This CPLD controls most of the Q-Bus signals including
the data path and the register interface for the microcontroller. This is the
version for the Q-Bus hardware. 

## QBUSEMUDMA.PLD

This is the secondary CPLD which implements the DMA state machine. This is the
version for the Q-Bus hardware.

## DISKEMUMAIN.PLD 

This is the master CPLD. This CPLD controls most of the Q-Bus signals including
the data path and the register interface for the microcontroller. This is the
version for the QBUS64 hardware. 

## DISKEMUDMA.PLD

This is the secondary CPLD which implements the DMA state machine. This is the
version for the QBUS64 hardware.

