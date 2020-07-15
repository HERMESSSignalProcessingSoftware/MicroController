/*
 * cypress.h
 *
 *  Created on: Jun 4, 2020
 *      Author: tobias
 */

#ifndef INC_CYPRESS_H_
#define INC_CYPRESS_H_

//Cypress commands

#define c_READID 0x9F
#define c_READ 0x13
#define c_WRITEPAGE 0x12
#define c_WREN 0x06
#define c_WRDI 0x04
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

uint8_t readStatus(SPI_Values SPI_val);
int writeByte(uint8_t data,SPI_Values SPI_val);
int writePage(uint8_t *data, uint32_t address, SPI_Values SPI_val);
int readPage(uint8_t *data, uint32_t address, SPI_Values SPI_val);
int chipErase(SPI_Values SPI_val);
uint32_t testMemory(void);
void writeReady(SPI_Values SPI_val);


#endif /* INC_CYPRESS_H_ */






