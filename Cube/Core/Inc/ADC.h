/*
 * ADC.h
 *
 *  Created on: Aug 7, 2020
 *      Author: Robin Grimsmann
 */

#ifndef INC_ADC_H_
#define INC_ADC_H_

#include "main.h"



#define CMD_RESET 0x07
#define CMD_SDATAC 0x17
#define CMD_RDATAC 0x14
#define CMD_SYNC 0x04
#define CMD_SELFOCAL 0x62
#define CMD_SYSOCAL 0x60
#define CMD_SYSGCAL 0x61

/* IPR Added Functions */
uint16_t ReadADC4(void);

/* END OF IPR ADDED FUNCTIONS */
/**
 * Performes initalisation of the ADC
 *
 */
void InitADC(void);

/**
 * @param void ptr to memory region storing the datastruct
 */
void ReadADCs(void * memoryregion);

/**
 * Starts the ADCs and sends command sync
 * After this functions ADC  interrupts will be coming!
 */
void StartADC(void);



#endif /* INC_ADC_H_ */
