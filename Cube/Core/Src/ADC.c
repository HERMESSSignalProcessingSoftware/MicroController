/*
 * ADC.c
 *
 *  Created on: Aug 7, 2020
 *      Author: Robin Grimsmann
 */

#include "ADC.h"
#include "spi.h"

void sendCommand(uint8_t *pToSend, uint32_t count) {
	HAL_SPI_Transmit(&hspi4, pToSend, count, 10);
}

/**
 * Starts the ADCs and sends command sync
 * After this functions ADC  interrupts will be coming!
 */
void StartADC(void) {
	uint8_t cmd = CMD_RESET;
	/* Send command read data continuous */
	HAL_GPIO_WritePin(nCS_DMS4_GPIO_Port, nCS_DMS4_Pin, RESET);
	cmd = CMD_RDATAC;
	sendCommand(&cmd, 1);
	HAL_GPIO_WritePin(nCS_DMS4_GPIO_Port, nCS_DMS4_Pin, SET);
}

/**
 * Performes initalisation of the ADC
 *
 */
void InitADC(void) {
	uint8_t wregCmd[] = { 0x42, // WREG operation with start register address 2
			0x01, // Update two registers
			0x30, // Always on and selected internal reference
			0x72 // PGA 64 and 20 SPS
			};

	uint8_t rregCmd[] = { 0x22, 0x01 };

	uint8_t rregBuf[] = { 0xff, 0xff };
	/* Set all nCS Pins to high */
	HAL_GPIO_WritePin(nCS_DMS4_GPIO_Port, nCS_DMS4_Pin, SET);
	/* Select ADC 4 */
	HAL_GPIO_WritePin(nCS_DMS4_GPIO_Port, nCS_DMS4_Pin, RESET);
	uint8_t cmd = CMD_RESET;
	sendCommand(&cmd, 1);
	HAL_Delay(2);
	cmd = CMD_SDATAC;
	sendCommand(&cmd, 1);
	sendCommand(wregCmd, 4);
	HAL_SPI_TransmitReceive(&hspi4, rregCmd, rregBuf, 2, 10);
	uint16_t checkVal = ((uint16_t) rregBuf[0] << 8) | rregBuf[1];
	if (checkVal != 0x3072) {
		//Unknown error
		for (;;)
			;
	}
	cmd = CMD_SYSOCAL;
	sendCommand(&cmd, 1);
	HAL_Delay(2000);
	HAL_GPIO_WritePin(nCS_DMS4_GPIO_Port, nCS_DMS4_Pin, SET);
}

/* IPR Added Functions */
uint16_t ReadADC4(void) {
	uint8_t buffer[] = { 0x00, 0x00 };
	uint8_t nops[] = { 0xFF, 0xFF };
	HAL_GPIO_WritePin(nCS_DMS4_GPIO_Port, nCS_DMS4_Pin, RESET);
	HAL_SPI_TransmitReceive(&hspi4, nops, buffer, 2, 10);
	HAL_GPIO_WritePin(nCS_DMS4_GPIO_Port, nCS_DMS4_Pin, SET);
	return ((uint16_t) (buffer[0] << 8) | buffer[1]);
}

/**
 * @param void ptr to memory region storing the datastruct
 */
void ReadADCs(void *memoryregion) {
	if (memoryregion) {

	}
}
