/*
 * cypress.c
 *
 *  Created on: 16.01.2021
 *      Author: Robin Grimsmann, Tobias Hausmann
 */

#include "cypress.h"
#include "main.h"
#include "spi.h"
#include "cypress.h"
#include <stdbool.h>

//Write ready sperrt sich wenn WIP nicht 0 wird

uint8_t tmp_add;

/**
 * Function Read Status
 * reads the status byte from the memory unit
 * @param: SPI_val
 * @return 8 bit status register
 */
uint8_t readStatus(SPI_Values SPI_val) {
	uint8_t data;
	uint8_t command = c_READSTATUSREG1;
	//CS1 low
	HAL_GPIO_WritePin(SPI_val.CS_Port, SPI_val.CS_Pin, GPIO_PIN_RESET);
	//send command
	HAL_SPI_Transmit(SPI_val.spihandle, &command, 1, 10);
	//read data from status register
	HAL_SPI_Receive(SPI_val.spihandle, &data, 1, 10);
	//CS1 high
	HAL_GPIO_WritePin(SPI_val.CS_Port, SPI_val.CS_Pin, GPIO_PIN_SET);
	return data;
}

/**
 *  Function Write Byte
 *  @brief Writes one byte so SPI
 *  @param uint8_t data: the one byte
 *  @param SPI_Val: the specifier of the SPI
 *  @return 0: Ok.
 */
int writeByte(uint8_t data, SPI_Values SPI_val) {
	uint8_t command = data;
	//CS1 low
	HAL_GPIO_WritePin(SPI_val.CS_Port, SPI_val.CS_Pin, GPIO_PIN_RESET);
	//Ausgabe lesen
	HAL_SPI_Transmit(SPI_val.spihandle, &command, 1, 10);
	//CS1 high
	HAL_GPIO_WritePin(SPI_val.CS_Port, SPI_val.CS_Pin, GPIO_PIN_SET);
	return 0;
}

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
int writePage(uint8_t *data, uint32_t address, SPI_Values SPI_val) {

	uint8_t command = c_WRITEPAGE;
	uint8_t tmp_add;

//Write enable
	writeByte(c_WREN, SPI_val);

	//CS1 low
	HAL_GPIO_WritePin(SPI_val.CS_Port, SPI_val.CS_Pin, GPIO_PIN_RESET);

	//commando schicken
	HAL_SPI_Transmit(SPI_val.spihandle, &command, 1, 10);
	HAL_Delay(10);
	//Addressse schicken MSB to LSB
//	HAL_SPI_Transmit(SPI_val.spihandle, (uint8_t*) (&address), 4, 40);

	tmp_add = (uint8_t) ((address >> 24) & 0x000000FF);
	HAL_SPI_Transmit(SPI_val.spihandle, &tmp_add, 1, 10);
	tmp_add = (uint8_t) ((address >> 16) & 0x000000FF);
	HAL_SPI_Transmit(SPI_val.spihandle, &tmp_add, 1, 10);
	tmp_add = (uint8_t) ((address >> 8) & 0x000000FF);
	HAL_SPI_Transmit(SPI_val.spihandle, &tmp_add, 1, 10);
	tmp_add = (uint8_t) (address & 0x000000FF);
	HAL_SPI_Transmit(SPI_val.spihandle, &tmp_add, 1, 10);

	//Daten schicken
//	HAL_SPI_Transmit(SPI_val.spihandle, data, 256, HAL_MAX_DELAY);
	for (int i = 0; i < 256; i++) {
		HAL_SPI_Transmit(SPI_val.spihandle, &data[i], 1, 10);
	}

	//CS1 high
	HAL_GPIO_WritePin(SPI_val.CS_Port, SPI_val.CS_Pin, GPIO_PIN_SET);

	//Write disable
	writeByte(c_WRDI, SPI_val);
	return 0;
}

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
int readPage(uint8_t *data, uint32_t address, SPI_Values SPI_val) {

	uint8_t command = c_READ;

	//CS1 low
	HAL_GPIO_WritePin(SPI_val.CS_Port, SPI_val.CS_Pin, GPIO_PIN_RESET);

	//commando schicken
//	writeByte(c_READ, SPI_val);
	HAL_SPI_Transmit(SPI_val.spihandle, &command, 1, 10);

//4 Byte Addressse schicken MSB to LSB
//	HAL_SPI_Transmit(SPI_val.spihandle, (uint8_t*) (&address), 4, 40);
	tmp_add = (uint8_t) ((address >> 24) & 0x000000FF);
	HAL_SPI_Transmit(SPI_val.spihandle, &tmp_add, 1, 10);
	tmp_add = (uint8_t) ((address >> 16) & 0x000000FF);
	HAL_SPI_Transmit(SPI_val.spihandle, &tmp_add, 1, 10);
	tmp_add = (uint8_t) ((address >> 8) & 0x000000FF);
	HAL_SPI_Transmit(SPI_val.spihandle, &tmp_add, 1, 10);
	tmp_add = (uint8_t) (address & 0x000000FF);
	HAL_SPI_Transmit(SPI_val.spihandle, &tmp_add, 1, 10);

//Daten lesen
//	HAL_SPI_Receive(SPI_val.spihandle, data, 256, 2560);
	for (int i = 0; i < 256; i++) {
		HAL_SPI_Receive(SPI_val.spihandle, &data[i], 1, 10);
	}

//CS1 high
	HAL_GPIO_WritePin(SPI_val.CS_Port, SPI_val.CS_Pin, GPIO_PIN_SET);

	return 0;
}

/**
 * Function Chip Erase
 * Erases the whole chip
 * @param SPI_Values SPI_val: the corresponding memory ic
 */
int chipErase(SPI_Values SPI_val) {
	//Write enable
	writeByte(c_WREN, SPI_val);
	//erase chip
	writeByte(c_CE, SPI_val);
	//Write Disable
	writeByte(c_WRDI, SPI_val);
	//warte bis Schreiben beendet ist
	writeReady(SPI_val);

	return 0;
}

/* TODO: DOCUMENTATION!!
 *  UNDOCUMENTED
 * */
int readBytes(uint8_t *data, uint32_t address, int count, SPI_Values SPI_val) {

	if (count > sizeof(data)) {
		return 1;
	}

	uint8_t command = c_READ;

	//CS1 low
	HAL_GPIO_WritePin(SPI_val.CS_Port, SPI_val.CS_Pin, GPIO_PIN_RESET);

	//commando schicken
	HAL_SPI_Transmit(SPI_val.spihandle, &command, 1, 10);

	//4 Byte Addressse schicken MSB to LSB
	tmp_add = (uint8_t) ((address >> 24) & 0x000000FF);
	HAL_SPI_Transmit(SPI_val.spihandle, &tmp_add, 1, 10);
	tmp_add = (uint8_t) ((address >> 16) & 0x000000FF);
	HAL_SPI_Transmit(SPI_val.spihandle, &tmp_add, 1, 10);
	tmp_add = (uint8_t) ((address >> 8) & 0x000000FF);
	HAL_SPI_Transmit(SPI_val.spihandle, &tmp_add, 1, 10);
	tmp_add = (uint8_t) (address & 0x000000FF);
	HAL_SPI_Transmit(SPI_val.spihandle, &tmp_add, 1, 10);

	//Daten lesen
	for (int i = 0; i < count; i++) {
		HAL_SPI_Receive(SPI_val.spihandle, &data[i], 1, 10);
	}

	//CS1 high
	HAL_GPIO_WritePin(SPI_val.CS_Port, SPI_val.CS_Pin, GPIO_PIN_SET);

	return 0;
}

/**
 * Waits for the bit WIP (Write in Progress) bit to toggle
 * Reads SR1 register from memory
 */
void writeReady(SPI_Values SPI_val) {
	uint32_t status = 0;
	uint8_t SR1 = 0xF;
	while (status == 0) {
		SR1 = readStatus(SPI_val);
		if ((SR1 & 0x1) == 0)
			status = 1;
	}
}

