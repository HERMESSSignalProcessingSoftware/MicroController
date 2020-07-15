/*
 * Callback.c
 *
 *  Created on: Jul 3, 2020
 *      Author: Robin Grimsmann
 */

#include "main.h"
#include "spi.h"
#include <stdio.h>
#include <stdlib.h>
#include "cmsis_os.h"
#include "usart.h"

#include "ADCTest.h"

extern  osThreadId_t defaultTaskHandle;

void HAL_GPIO_EXTI_Callback(uint16_t GPIO_Pin) { // Externer Interrupt Callback
	HAL_GPIO_WritePin(Time_GPIO_Port, Time_Pin, GPIO_PIN_SET);
	//uint16_t data[2] = {1,1};
//	if (GPIO_Pin == nDRDY_Pin) {
//		//HAL_SPI_Receive(&hspi5, (uint8_t *)&data[0],2,3);
//		//HAL_GPIO_WritePin(GPIOE, GPIO_PIN_6, GPIO_PIN_RESET); //START->
//		//HAL_GPIO_WritePin(GPIOG, GPIO_PIN_1, GPIO_PIN_SET); // CS deaktiviert DRDY?
//		//osEventFlagsSet(DRDY_FLAG_ID, DRDY_FLAG);
//		if (i == 0) { // Ansonsten keine WErte auslesbar Ursache noch unklar
//			HAL_GPIO_WritePin(nRES_GPIO_Port, nRES_Pin, GPIO_PIN_SET);
//			HAL_Delay(10);
//			HAL_GPIO_WritePin(nRES_GPIO_Port, nRES_Pin, GPIO_PIN_SET);
//
//		}
////		HAL_GPIO_WritePin(LD2_GPIO_Port, LD2_Pin, GPIO_PIN_SET);		//LIcht
//		HAL_GPIO_WritePin(nCS_GPIO_Port, nCS_Pin, GPIO_PIN_RESET);		//CS LOW
//		//HAL_SPI_Receive(&hspi5, (uint8_t *)&receivingdata[0],2,1);//
//
//		HAL_SPI_Transmit(&hspi3, &rdata, 1, 1);
//
//		HAL_SPI_TransmitReceive(&hspi3, &nop, &receivingdata, 2, 1);//Pointer incompatible  WARUM??????????
//		HAL_GPIO_WritePin(nCS_GPIO_Port, nCS_Pin, GPIO_PIN_SET);
////		HAL_GPIO_WritePin(GPIOB, GPIO_PIN_7, GPIO_PIN_RESET);
//		if ((i < 1024)) {
//			//result[i] = ((uint16_t) receivingdata[1] << 8) | receivingdata[2];
//			i++;
//		} else {
//			HAL_NVIC_DisableIRQ(EXTI15_10_IRQn);
//			HAL_UART_Transmit_IT(&huart2, (uint8_t*)result, 2048);
//			HAL_NVIC_EnableIRQ(EXTI15_10_IRQn);
//			i = 0;
//		}
//		result[i] = ((uint16_t) receivingdata[0] << 8) | receivingdata[1];
//
//	}
	HAL_GPIO_WritePin(Time_GPIO_Port, Time_Pin, GPIO_PIN_RESET);
}
