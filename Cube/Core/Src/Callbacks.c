/*
 * Callbacks.c
 *
 *  Created on: 26.05.2020
 *      Author: Robin Grimsmann
 */


#include "spi.h"
#include "main.h"
#include "FreeRTOS.h"
#include "FreeRTOSConfig.h"
#include "cmsis_os.h"
#include <stdlib.h>

volatile uint32_t spi6txCnt = 0;


extern osThreadId_t MemoryTaskHandle;

/**
 *
 */
void HAL_SPI_TxHalfCpltCallback (SPI_HandleTypeDef * hspi) {

}

/**
 *
 */
void HAL_SPI_RxHalfCpltCallback (SPI_HandleTypeDef *hspi)  {

}

void HAL_SPI_ErrorCallback (SPI_HandleTypeDef * hspi) {
	uint8_t *msg = (uint8_t*)malloc(256);
	uint32_t spiN = 0;
	if (hspi->Instance == SPI2) {
		spiN = 2;
	} else if (hspi->Instance == SPI3) {
		spiN = 3;
	} else if (hspi->Instance == SPI4) {
		spiN = 4;
	} else if (hspi->Instance == SPI5) {
		spiN = 5;
	} else if (hspi->Instance == SPI6) {
		spiN = 6;
	} else {
		spiN = 255;
	}

	sprintf(msg, "SPI %d Critical! \n\r\0", spiN);
	Huart4_send(msg, strlen(msg));
	free(msg);
}

void HAL_SPI_TxCpltCallback(SPI_HandleTypeDef *hspi) {
	volatile uint8_t x = 5;
	if (hspi->Instance == hspi2.Instance) {
		spi6txCnt;
	} else if (hspi->Instance == hspi6.Instance) {
		spi6txCnt++;
	//	osSignalSet(MemoryTaskHandle, 0x02);

	}
}

void HAL_SPI_RxCpltCallback(SPI_HandleTypeDef *hspi) {
	volatile uint8_t y = 5;
	if (hspi->Instance == hspi2.Instance) {
		spi6txCnt;
	} else if (hspi->Instance == hspi6.Instance) {
		spi6txCnt  += y;
		InterSPUTransmit("!", 1);
		//osSignalSet(MemoryTaskHandle, 0x01);
	}
}
