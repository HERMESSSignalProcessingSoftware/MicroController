/*
 * Memory.h
 *
 *  Created on: Aug 7, 2020
 *      Author: Robin Grimsmann
 */

#ifndef INC_MEMORY_H_
#define INC_MEMORY_H_

#include "main.h"

//Cypress commands


#define c_WRDI 0x04
#define c_READSTATUSREG1 0x05
#define c_WREN 0x06
#define c_READSTATUSREG2 0x07
#define c_WRITEPAGE 0x12
#define c_READ 0x13
#define c_READID 0x9F
#define c_CE 0xC7

typedef struct{
	SPI_HandleTypeDef *spihandle;
	uint16_t CS_Pin;
	GPIO_TypeDef* CS_Port;
}SPI_Values;

typedef struct {
	uint32_t timer;
	int16_t DMS_Data[6];
	int16_t Temp_Data[3];
}Datensatz;


/**
 * Writes a page to memory
 * Provide a simple interface for usage from state machine
 *
 * @param the ptr to the page
 */
void WriteToMemory(void * memoryregion);

#endif /* INC_MEMORY_H_ */
