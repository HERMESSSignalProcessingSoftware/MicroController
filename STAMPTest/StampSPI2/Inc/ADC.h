/**
 * Author: R. Grimsmann
 *
 */
#ifndef __ADC_H__
#define __ADC_H__

#include "main.h"

uint8_t receivingdata[4] = {1,1,1,1};
uint8_t readdata[4]= {0x12,0xff,0xff,0xff}; // READ DATA Befehlssatz
uint8_t readregister[2]= {0x20, 0x03}; // READ Register Befehlssatz
uint8_t nop[2] = {0xff,0xff}; // NOP Befehle

uint8_t reset_command[1] = {0x06};
uint8_t sdatac_command[1] = {0x16};
/*Modified Wreg command to set SYS (last byte in array below to 0x4f)*/
uint8_t wreg_command[6] = {0x40, 0x03, 0x01, 0x00, 0x00, 0x4f};//BCS -> RESET dann CHANNEL ANX0 auswahl
uint8_t sync_command[1] = {0x04};

uint8_t rdata[1] = {0x12};

/* The SYSOCAL command initiates a system offset calibration.
 * For a system offset calibration,the inputs must be externally shorted to a voltage within the input
 * common-mode range.
 * The inputs must be near the mid-supply voltage of (AVDD+ AVSS)/ 2.
 * The OFC register sis updated when the command completes.*/
uint8_t sysocal[1] 	= {0x60};

/* The SYSGCAL command initiates the system gain calibration.
 * For a system gain calibration,the input must be set to full-scale.
 * The FSC registeris updated after this operation.*/
uint8_t sysgcal[1] 	= {0x61};

/* The SELFOCAL command initiates a self offsetcalibration.
 * The device internally shorts the inputs to mid-supply and performs the calibration.
 * The OFC register is updated after this operation.*/
uint8_t selfocal[1] 	= {0x62};

#endif
