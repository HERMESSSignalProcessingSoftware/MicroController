#ifndef __ADC_TEST_H
#define __ADC_TEST_H

#include "main.h"

#include "cmsis_os2.h"


extern SPI_HandleTypeDef hspi3;
extern uint8_t receivingdata[4];
extern uint8_t readdata[3]; // READ DATA Befehlssatz
extern uint8_t readregister[2]; // READ Register Befehlssatz
extern uint8_t nop[2]; // NOP Befehle
extern uint8_t transmitdata[3]; // READ DATA Befehlssatz und 16 SCLK's
extern uint16_t result[300]; //FANGVARIABLE
extern uint8_t registervalue[6]; //ERGEBNIS des Registers
extern uint8_t reset_command[1];
extern uint8_t sdatac_command[1];
extern uint8_t wreg_command[6]; //BCS -> RESET dann CHANNEL ANX0 auswahl
extern uint8_t sync_command[1];
extern int i;

/* The SYSOCAL command initiates a system offset calibration.
 * For a system offset calibration,the inputs must be externally shorted to a voltage within the input
 * common-mode range.
 * The inputs must be near the mid-supply voltage of (AVDD+ AVSS)/ 2.
 * The OFC register sis updated when the command completes.*/
extern uint8_t sysocal[1];

/* The SYSGCAL command initiates the system gain calibration.
 * For a system gain calibration,the input must be set to full-scale.
 * The FSC register is updated after this operation.*/
extern uint8_t sysgcal[1];

/* The SELFOCAL command initiates a self offset calibration.
 * The device internally shorts the inputs to mid-supply and performs the calibration.
 * The OFC register is updated after this operation.*/
extern uint8_t selfocal[1];

extern uint8_t rdata[1];

uint32_t adc_test(void);

#endif
