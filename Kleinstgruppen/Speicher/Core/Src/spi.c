/*
 * spi.c
 *
 *  Created on: Jun 4, 2020
 *      Author: tobias
 */

//Write ready sperrt sich wenn WIP nicht 0 wird

#include "main.h"
#include "cmsis_os.h"
#include "cypress.h"
#include <stdbool.h>

uint8_t tmp_add;

uint8_t readStatus(SPI_Values SPI_val)
{
	uint8_t	data;
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

//send one Byte to spi
int writeByte(uint8_t data,SPI_Values SPI_val)
{
	uint8_t command = data;
	//CS1 low
	HAL_GPIO_WritePin(SPI_val.CS_Port, SPI_val.CS_Pin, GPIO_PIN_RESET);
	//Ausgabe lesen
	HAL_SPI_Transmit(SPI_val.spihandle, &command, 1, 10);
	//CS1 high
	HAL_GPIO_WritePin(SPI_val.CS_Port, SPI_val.CS_Pin, GPIO_PIN_SET);
	return 0;
}



int writePage(uint8_t *data, uint32_t address, SPI_Values SPI_val){

	uint8_t command = c_WRITEPAGE;
	uint8_t tmp_add;

	//Write enable
	writeByte(c_WREN, SPI_val);

	//CS1 low
	HAL_GPIO_WritePin(SPI_val.CS_Port, SPI_val.CS_Pin, GPIO_PIN_RESET);

	//commando schicken
	HAL_SPI_Transmit(SPI_val.spihandle, &command, 1, 10);
	osDelay(10);
	//Addressse schicken MSB to LSB
	tmp_add = (uint8_t)((address >> 24) & 0x000000FF);
	HAL_SPI_Transmit(SPI_val.spihandle, &tmp_add, 1, 10);
	tmp_add = (uint8_t)((address >> 16) & 0x000000FF);
	HAL_SPI_Transmit(SPI_val.spihandle, &tmp_add, 1, 10);
	tmp_add = (uint8_t)((address >> 8)  & 0x000000FF);
	HAL_SPI_Transmit(SPI_val.spihandle, &tmp_add, 1, 10);
	tmp_add = (uint8_t)( address        & 0x000000FF);
	HAL_SPI_Transmit(SPI_val.spihandle, &tmp_add, 1, 10);

	//Daten schicken
	for (int i = 0; i < 256; i++)
	{
		HAL_SPI_Transmit(SPI_val.spihandle, &data[i], 1, 10);
	}

	//CS1 high
	HAL_GPIO_WritePin(SPI_val.CS_Port, SPI_val.CS_Pin, GPIO_PIN_SET);

	//Write disable
	writeByte(c_WRDI, SPI_val);
	return 0;
}

int readPage(uint8_t *data, uint32_t address,  SPI_Values SPI_val){

	uint8_t command = c_READ;

	//CS1 low
	HAL_GPIO_WritePin(SPI_val.CS_Port, SPI_val.CS_Pin, GPIO_PIN_RESET);

	//commando schicken
	HAL_SPI_Transmit(SPI_val.spihandle, &command, 1, 10);

	//4 Byte Addressse schicken MSB to LSB
	tmp_add = (uint8_t)((address >> 24) & 0x000000FF);
	HAL_SPI_Transmit(SPI_val.spihandle, &tmp_add, 1, 10);
	tmp_add = (uint8_t)((address >> 16) & 0x000000FF);
	HAL_SPI_Transmit(SPI_val.spihandle, &tmp_add, 1, 10);
	tmp_add = (uint8_t)((address >> 8)  & 0x000000FF);
	HAL_SPI_Transmit(SPI_val.spihandle, &tmp_add, 1, 10);
	tmp_add = (uint8_t)( address        & 0x000000FF);
	HAL_SPI_Transmit(SPI_val.spihandle, &tmp_add, 1, 10);

	//Daten lesen
	for (int i = 0; i < 256; i++)
	{
		HAL_SPI_Receive(SPI_val.spihandle, &data[i], 1, 10);
	}

	//CS1 high
	HAL_GPIO_WritePin(SPI_val.CS_Port, SPI_val.CS_Pin, GPIO_PIN_SET);

	return 0;
}

int chipErase(SPI_Values SPI_val){
	//Write enable
	writeByte(c_WREN,SPI_val);
	//erase chip
	writeByte(c_CE,SPI_val);
	//Write Disable
	writeByte(c_WRDI,SPI_val);
	//warte bis Schreiben beendet ist
	writeReady(SPI_val);

	return 0;
}

int readBytes(uint8_t *data, uint32_t address, int count, SPI_Values SPI_val){

	if(count > sizeof(data))
		{return 1;}

	uint8_t command = c_READ;

	//CS1 low
	HAL_GPIO_WritePin(SPI_val.CS_Port, SPI_val.CS_Pin, GPIO_PIN_RESET);

	//commando schicken
	HAL_SPI_Transmit(SPI_val.spihandle, &command, 1, 10);

	//4 Byte Addressse schicken MSB to LSB
	tmp_add = (uint8_t)((address >> 24) & 0x000000FF);
	HAL_SPI_Transmit(SPI_val.spihandle, &tmp_add, 1, 10);
	tmp_add = (uint8_t)((address >> 16) & 0x000000FF);
	HAL_SPI_Transmit(SPI_val.spihandle, &tmp_add, 1, 10);
	tmp_add = (uint8_t)((address >> 8)  & 0x000000FF);
	HAL_SPI_Transmit(SPI_val.spihandle, &tmp_add, 1, 10);
	tmp_add = (uint8_t)( address        & 0x000000FF);
	HAL_SPI_Transmit(SPI_val.spihandle, &tmp_add, 1, 10);

	//Daten lesen
	for (int i = 0; i < count; i++)
	{
		HAL_SPI_Receive(SPI_val.spihandle, &data[i], 1, 10);
	}

	//CS1 high
	HAL_GPIO_WritePin(SPI_val.CS_Port, SPI_val.CS_Pin, GPIO_PIN_SET);

	return 0;
}

void writeReady(SPI_Values SPI_val){
	bool status = false;
	uint8_t SR1 = 0xF;
	while(status == false)
	{
		SR1 = readStatus(SPI_val);
		if((SR1 & 0x1) == 0)
			status = true;
	}
}

