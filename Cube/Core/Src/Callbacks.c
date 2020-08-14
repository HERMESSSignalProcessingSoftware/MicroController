/*
 * Callbacks.c
 *
 *  Created on: 26.05.2020
 *      Author: Robin Grimsmann
 */


#include "spi.h"
#include "main.h"
#include <stdlib.h>
#include "SPU.h"

volatile uint32_t spi6txCnt = 0;


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
//	uint8_t *msg = (uint8_t*)malloc(256);
//	uint32_t spiN = 0;
//	if (hspi->Instance == SPI2) {
//		spiN = 2;
//	} else if (hspi->Instance == SPI3) {
//		spiN = 3;
//	} else if (hspi->Instance == SPI4) {
//		spiN = 4;
//	} else if (hspi->Instance == SPI5) {
//		spiN = 5;
//	} else if (hspi->Instance == SPI6) {
//		spiN = 6;
//	} else {
//		spiN = 255;
//	}
//
//	sprintf(msg, "SPI %d Critical! \n\r\0", spiN);
//	//Huart4_send(msg, strlen(msg));
//	free(msg);
}

void HAL_SPI_TxCpltCallback(SPI_HandleTypeDef *hspi) {
	/*if (hspi->Instance == hspi6.Instance) {

	}*/
}

void HAL_SPI_RxCpltCallback(SPI_HandleTypeDef *hspi) {

}


/* Overwrite the internal void HAL_GPIO_EXTI_Callback(uint16_t GPIO_Pin) function */
void HAL_GPIO_EXTI_Callback(uint16_t GPIO_Pin) {
	switch (GPIO_Pin) {
	case SODS_OPT_Pin:
		Toggle(SODS);
		break;
	case SOE_OPT_Pin:
		Toggle(SOE);
		break;
	case LO_OPT_Pin:
		Toggle(LO);
		break;
	default: ; //label has to be followed by a statement, declearation is not a statment..
		uint8_t t = ADCLookup[LOOKUP_PIN_INDEX(GPIO_Pin)];
		ADCBitMap = ADCBitMap & (~(0x1 << t));
		break;
	}
}
