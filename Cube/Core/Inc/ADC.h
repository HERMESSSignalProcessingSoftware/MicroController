/*
 * ADC.h
 *
 *  Created on: Aug 7, 2020
 *      Author: Robin Grimsmann
 */

#ifndef INC_ADC_H_
#define INC_ADC_H_

#include "main.h"


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
