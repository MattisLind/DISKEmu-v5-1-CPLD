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

## Versions

### v1.0.0

Initial Version

### v1.1.0

Add write-only device register 6. Bit 0, when set, additionally decodes the
ROM addresses 173000<sub>8</sub>..173177<sub>8</sub>. This allows the MSCP
Emulator also to act as small, 64. words, boot ROM, sufficient for a bootstrap
to DU:, or in case of RLV12 emulation firmware a small bootstrap for DL: 

A bootstrap at address 173000<sub>8</sub> is especially useful in case you
set the PDP-11 to autostart the ROM at 173000<sub>8</sub>.

Requires MSCP Emulator firmware for the Microcontroller v1.3.0 or higher

### v2.0.0

Bit 1 of device register 6 now selects between primary and secondary
device register address. When cleared the primary address for the MSCP
or RLV12 emulation is selected, which is 172150<sub>8</sub> or 174400<sub>8</sub>
respectively. When set the secondary device register addresses are
activated, 160334<sub>8</sub> or 174420<sub>8</sub>. 

Pin MSCP of the CPLD is used to switch between MSCP and RLV12 device
register addresses. This is subject to change and be replaced by bit 2
of register 6 with a future release.

Requires MSCP Emulator firmware for the Microcontroller v2.0.0 or higher
