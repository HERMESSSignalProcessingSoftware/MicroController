/*
 * cypress.h
 *
 *  Created on: 16.01.2021
 *      Author: Robin Grimsmann
 */

#ifndef INC_CYPRESS_H_
#define INC_CYPRESS_H_

#include "main.h"
#include "gpio.h"
#include "spi.h"
//Cypress commands

#define c_WRDI 0x04
#define c_READSTATUSREG1 0x05
#define c_READSTATUSREG2 0x07
#define c_READCONFIGREG1 0x35
#define c_CLEARSTATUSREG1 0x30
#define c_WREN 0x06
#define c_READSTATUSREG2 0x07
#define c_WRITEPAGE 0x12
#define c_READ 0x13
#define c_READID 0x9F

/*Warining: Chip Erease below!*/
#define c_CE 0xC7


/**
 * spihandle = hspin where n E {1,2,...,m}
 * CS_Pin = the Pin connected to n_chipselect of the corresponding flash memory
 * CS_Port = GPION N E {A,B,...,E}
 */
typedef struct {
	SPI_HandleTypeDef *spihandle;
	uint16_t CS_Pin;
	GPIO_TypeDef *CS_Port;
} SPI_Values;

/**
 * Dataframe for one measurment point
 */
typedef struct {
	uint32_t timer;
	int16_t DMS_Data[6];
	int16_t Temp_Data[3];
} Datensatz;


/**
 * Sets the pin to the right state
 * @returns 0: ok
 */
int32_t InitMemory(void);

/**
 * Function Read Status
 * reads the status byte from the memory unit
 * @param: SPI_val
 * @return 8 bit status register
 */
uint8_t readStatus(SPI_Values SPI_val);

/**
 *  Function Write Byte
 *  @brief Writes one byte so SPI
 *  @param uint8_t data: the one byte
 *  @param SPI_Val: the specifier of the SPI
 *  @return 0: Ok.
 */
int writeByte(uint8_t data, SPI_Values SPI_val);

/**
 * Function Write Page
 * @brief Transmits command C_WREN (write enable) to the SPI
 * C_WRITEPAGE. Transfert address now, after that you have to transfer one page (256 byte) of data.
 *
 * Data overview
 *
 * Byte	:	1		2	 		3-6		7 - 263 	264
 * Ddata:	c_WREN	c_WRITEPAGE	ADDR	DATA		c_WRDI
 *
 * @param uint8_t * data: Pointer to the data field
 * @param uint32_t address: the address on the memory chip
 * @param SPI_Values SPI_val
 * @return 0: ok
 */
int writePage(uint8_t *data, uint32_t address, SPI_Values SPI_val);

/**
 * Function Read Page
 * @brief
 * Reads one page from the memory unit. The address determines which page is going to be read.
 *
 * Data overview:
 * To Memory IC:
 * Byte:	1		2 - 5
 * Data:	c_READ	Address
 *
 * From Memory IC:
 * Byte: 	0 - 256
 * Data:	Data
 *
 * @param uint8_t  * data: Pointer to the data array
 * @param uint32_t address: Address of the momory unit to be read
 * @param SPI_Values SPI_val: the corresponding SPI values
 * @return 0: ok
 */
int readPage(uint8_t *data, uint32_t address, SPI_Values SPI_val);

/**
 * Function Chip Erase
 * Erases the whole chip
 * @param SPI_Values SPI_val: the corresponding memory ic
 */
int chipErase(SPI_Values SPI_val);

/**
 * Waits for the bit WIP (Write in Progress) bit to toggle
 * Reads SR1 register from memory
 */
void writeReady(SPI_Values SPI_val);

/**
 * FOR TESTING PURPOSE
 */
uint32_t testMemory(void);

#endif /* INC_CYPRESS_H_ */
