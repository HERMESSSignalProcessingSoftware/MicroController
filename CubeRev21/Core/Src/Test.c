/*
 * Test.c
 *
 *  Created on: 16.01.2021
 *      Author: Robin Grimsmann
 */

#include "main.h"
#include "spi.h"
#include "Test.h"
#include "cypress.h"

#define PAGE_COUNT 125000

/**
 * Performes a fast memory test, just writes one page and reads it
 *
 */
uint32_t FastMemoryTest(UART_HandleTypeDef huart) {

	char writeBuffer[256] = "Starting FLASH Test...\r\n";
	HAL_UART_Transmit(&huart, writeBuffer, strlen(writeBuffer), HAL_MAX_DELAY);

	SPI_Values DUT0;
	DUT0.CS_Pin = FL2_CS1_Pin;
	DUT0.CS_Port = FL2_CS1_GPIO_Port;
	DUT0.spihandle = &hspi2;
	//
	SPI_Values DUT1;
	DUT1.CS_Pin = FL2_CS2_Pin;
	DUT1.CS_Port = FL2_CS2_GPIO_Port;
	DUT1.spihandle = &hspi2;
	//
	SPI_Values DUT2;
	DUT2.CS_Pin = FL1_CS1_Pin;
	DUT2.CS_Port = FL1_CS1_GPIO_Port;
	DUT2.spihandle = &hspi6;
	//
	SPI_Values DUT3;
	DUT3.CS_Pin = FL1_CS2_Pin;
	DUT3.CS_Port = FL1_CS2_GPIO_Port;
	DUT3.spihandle = &hspi6;


	uint32_t result = 0;
	uint32_t startTime = 0;
	uint32_t endTime = 0;

	sprintf(writeBuffer, "\t%s\n\r\0", "Checking FL2/1");
	HAL_UART_Transmit(&huart, writeBuffer, strlen(writeBuffer), HAL_MAX_DELAY);
	startTime = HAL_GetTick();
	result = FastTest(DUT0);
	endTime = HAL_GetTick() - startTime;
	sprintf(writeBuffer, "\t\tResult: %s, took %dms\r\n\0", result == 1 ? "Passed" : "Failed", endTime);
	HAL_UART_Transmit(&huart, writeBuffer, strlen(writeBuffer), HAL_MAX_DELAY);
	HAL_Delay(50);


	sprintf(writeBuffer, "\t%s\n\r\0", "Checking FL2/2");
	HAL_UART_Transmit(&huart, writeBuffer, strlen(writeBuffer), HAL_MAX_DELAY);
	startTime = HAL_GetTick();
	result = FastTest(DUT1);
	endTime = HAL_GetTick() - startTime;
	sprintf(writeBuffer, "\t\tResult: %s, took %dms\r\n\0", result == 1 ? "Passed" : "Failed", endTime);
	HAL_UART_Transmit(&huart, writeBuffer, strlen(writeBuffer), HAL_MAX_DELAY);
	HAL_Delay(50);


	sprintf(writeBuffer, "\t%s\n\r\0", "Checking FL1/1");
	HAL_UART_Transmit(&huart, writeBuffer, strlen(writeBuffer), HAL_MAX_DELAY);
	startTime = HAL_GetTick();
	result = FastTest(DUT2);
	endTime = HAL_GetTick() - startTime;
	sprintf(writeBuffer, "\t\tResult: %s, took %dms\r\n\0", result == 1 ? "Passed" : "Failed", endTime);
	HAL_UART_Transmit(&huart, writeBuffer, strlen(writeBuffer), HAL_MAX_DELAY);
	HAL_Delay(50);


	sprintf(writeBuffer, "\t%s\n\r\0", "Checking FL1/2");
	HAL_UART_Transmit(&huart, writeBuffer, strlen(writeBuffer), HAL_MAX_DELAY);
	startTime = HAL_GetTick();
	result = FastTest(DUT3);
	endTime = HAL_GetTick() - startTime;
	sprintf(writeBuffer, "\t\tResult: %s, took %dms\r\n\0", result == 1 ? "Passed" : "Failed", endTime);
	HAL_UART_Transmit(&huart, writeBuffer, strlen(writeBuffer), HAL_MAX_DELAY);
	HAL_Delay(50);




	return 0;
}

uint32_t FastTest(SPI_Values DUT) {
	uint8_t writeBuffer[256] = { 0 };
	uint8_t readBuffer[256] = { 0 };
	uint32_t adresse = 0;
	volatile uint8_t SR1;
	//Testdaten initialisieren
	for (int i = 0; i < 256; i++) {
		writeBuffer[i] = i;
	}

	//CHIP löschen
	//chipErase(DUT);
	//evtl Zusätzliche Schleife für die verschiedenen Chips und CS pins

	adresse = 0x0;
	//Daten für eine Page schicken
	writePage(writeBuffer, adresse, DUT);
	//Warten bis fertig geschrieben wurde
	writeReady(DUT);
	//Selbe page auslesen
	readPage(readBuffer, adresse, DUT);
	//Inhalt vergleichen
	for (int y = 0; y < 256; y++) {
		//Wenn inhalt nicht gleich
		if (writeBuffer[y] != readBuffer[y]) {
			SR1 = readStatus(DUT);
			return 0;
		}
	}
	return 1;
}

/**
 * @brief: tests the memory
 * TEST: Write to memory, wait, read form memory.
 * @return 0: Passed.
 */
uint32_t MemoryTest(void) {
	SPI_Values DUT0;
	DUT0.CS_Pin = FL2_CS1_Pin;
	DUT0.CS_Port = FL2_CS1_GPIO_Port;
	DUT0.spihandle = &hspi2;
	//
	SPI_Values DUT1;
	DUT1.CS_Pin = FL2_CS2_Pin;
	DUT1.CS_Port = FL2_CS2_GPIO_Port;
	DUT1.spihandle = &hspi2;
	//
	SPI_Values DUT2;
	DUT2.CS_Pin = FL1_CS1_Pin;
	DUT2.CS_Port = FL1_CS1_GPIO_Port;
	DUT2.spihandle = &hspi6;
	//
	SPI_Values DUT3;
	DUT1.CS_Pin = FL1_CS2_Pin;
	DUT1.CS_Port = FL1_CS2_GPIO_Port;
	DUT1.spihandle = &hspi6;

	uint32_t result = 1;
	result &= MemoryTestDUT(DUT0);
	result &= MemoryTestDUT(DUT1);
	result &= MemoryTestDUT(DUT2);
	result &= MemoryTestDUT(DUT3);
	return !result; //to create the 0 if the test passed!

}

/**
 * @retun: 1: passed
 */
uint32_t MemoryTestDUT(SPI_Values dut) {
	uint8_t writeBuffer[256] = { 0 };
	uint8_t readBuffer[256] = { 0 };
	volatile uint8_t SR1;
	uint32_t adresse = 0;

	//Testdaten initialisieren
	for (int i = 0; i < 256; i++) {
		writeBuffer[i] = i;
	}
	//CHIP löschen
	chipErase(dut);
	//evtl Zusätzliche Schleife für die verschiedenen Chips und CS pins
	for (int i = 0; i < PAGE_COUNT; i++) {
		adresse = i * 0x1000;
		//Daten für eine Page schicken
		writePage(writeBuffer, adresse, dut);
		//Warten bis fertig geschrieben wurde
		writeReady(dut);
		//Selbe page auslesen
		readPage(readBuffer, adresse, dut);
		//Inhalt vergleichen
		for (int y = 0; y < 256; y++) {
			//Wenn inhalt nicht gleich
			if (writeBuffer[y] != readBuffer[y]) {
				SR1 = readStatus(dut);
				return 0;
			}
		}
	}
	return 1;
}
