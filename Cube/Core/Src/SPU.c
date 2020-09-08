/*
 * SPU.c
 *
 *  Created on: Aug 7, 2020
 *      Author: Robin Grimsmann
 */
#include "main.h"
#include "SPU.h"
#include "usart.h"
#include <stdlib.h>
#include "stm32f7xx_hal.h"
#include "ADC.h"
#include "Memory.h"
#include "InterSPU.h"
#include "Telemetry.h"
#include "test.h"

Config_t config = { 0 };
uint32_t StartStop = 0;
/**
 * ADC Look Up Table
 */
uint8_t ADCLookup[NUMBER_OF_PINS] = { 0xFF, //Interrupt line 0
		0xFF, //Interrupt line 1
		0xFF, //Interrupt line 2
		0xFF, //Interrupt line 3
		0xFF, //Interrupt line 4
		0xFF, //Interrupt line 5
		0xFF, //Interrupt line 6
		0xFF, //Interrupt line 7
		0xFF, //Interrupt line 8
		0xFF, //Interrupt line 9
		4, //Interrupt line 10
		0xFF, //Interrupt line 11
		0x00, //Interrupt line 12
		0xFF, //Interrupt line 13
		0xFF, //Interrupt line 14
		0xFF  //Interrupt line 15
		};

/**
 * ADC bitmap
 * default value: 0xFFFFFFFF
 */
uint32_t ADCBitMap = ADCBITMAPNORMAL;

/**
 * Set the signal in the local config struct
 */
void SetSignal(Signal_t signal) {
	switch (signal) {
	case SODS:
		config.SODS = TRUE;
		break;
	case SOE:
		config.SOE = TRUE;
		break;
	case LO:
		config.LO = TRUE;
		break;
	default:
		break;
	}
}

/**
 * Clears the signal in the local config struct
 */
void ClearSignal(Signal_t signal) {
	switch (signal) {
	case SODS:
		config.SODS = FALSE;
		break;
	case SOE:
		config.SOE = FALSE;
		break;
	case LO:
		config.LO = FALSE;
		break;
	default:
		break;
	}
}

/**
 * Toggles the signal
 */
void Toggle(Signal_t signal) {
	switch (signal) {
	case SODS:
		if (config.SODS == TRUE) {
			config.SODS = FALSE;
		} else {
			config.SODS = TRUE;
		}
		break;
	case SOE:
		if (config.SOE == TRUE) {
			config.SOE = FALSE;
		} else {
			config.SOE = TRUE;
		}
		break;
	case LO:
		if (config.LO == TRUE) {
			config.LO = FALSE;
		} else {
			config.LO = TRUE;
		}
		break;
	default:
		break;
	}
}

/**
 * Returns the value of the signals
 * @return the values of the 3 signals, LO at bit 0,  SODS at bit 1 and SOE at bit 2
 */
uint32_t GetSignals(void) {
	uint32_t signals = 0x0;
	if (config.LO == TRUE)
		signals |= 0x1 << 0;
	if (config.SODS == TRUE)
		signals |= 0x1 << 1;
	if (config.SOE == TRUE)
		signals |= 0x1 << 2;
	return signals;
}

/**
 * Returns a specific signal
 * @return Bool_t TRUE if signal is set
 */
Bool_t GetSignal(Signal_t signal) {
	switch (signal) {
	case LO:
		return config.LO;
	case SODS:
		return config.SODS;
	case SOE:
		return config.SOE;
	default:
		return ERR;
	}
}

void SPURun(Config_t *config) {
	if (config) {
		if (config->secondary == FALSE) {
			/* Deinit huart8 (telemetry link) */
			HAL_UART_MspDeInit(&huart8);
		}
		uint32_t testRes = 0;
		uint8_t cmd = 0;
		uint32_t run = 1;
		uint16_t value = 0;
		uint32_t calCnt = 0;
		uint16_t cal[12] = { 0 };
		int64_t toggle = 0;
		InitADC();
		InitMemory();
		InitTelemetry();
		InitInterSPU();
		testRes = Test();
		if (testRes == 0) {
			//Test Failed Try recovery
		}
		void *memoryregion = malloc(256);
		uint32_t Counter = 0;
		uint32_t TelCounter = 0; //Saves the current value of the passed
//		while (GetSignal(SOE) == FALSE) { //Stay at state init as long as no signal SOE was set
//			//Do nothing
//		}
		start: HAL_UART_Receive_IT(&huart4, &cmd, 1);
		while (StartStop == 0)
			;
		HAL_UART_Receive_IT(&huart4, &cmd, 1);
		StartADC(); //Interrups will be coming state changes to data handling
		while (run == 1) {
			if (StartStop == 0) {
				run = 0;
			}
			if (GetSignal(SODS) == TRUE) {
				HAL_GPIO_WritePin(LED_2_GPIO_Port, LED_2_Pin, SET);
			} else {
				HAL_GPIO_WritePin(LED_2_GPIO_Port, LED_2_Pin, RESET);
			}
			if (GetSignal(LO) == TRUE) {
				HAL_GPIO_WritePin(LED_3_GPIO_Port, LED_3_Pin, SET);
			} else {
				HAL_GPIO_WritePin(LED_3_GPIO_Port, LED_3_Pin, RESET);
			}
			if (GetSignal(SOE) == TRUE) {
				HAL_GPIO_WritePin(LED_4_GPIO_Port, LED_4_Pin, SET);
			} else {
				HAL_GPIO_WritePin(LED_4_GPIO_Port, LED_4_Pin, RESET);
			}
			if (ADCBitMap == IPR_BITMAP) {
				/* Read data from ADC */
				value = ReadADC4();
				ADCBitMap = ADCBITMAPNORMAL;
			}
//			if (calCnt < 12) {
//				cal[calCnt++] = value;
//				if (cal[0] == 0) {
//					calCnt = 0;
//				}
//				if (calCnt == 12) {
//					int32_t s = 0;
//					for (uint32_t i = 0; i < 12; i++) {
//						s += cal[i];
//					}
//					cal[0] = s / 12;
//				}
//			} else {
			if (value != 0) {
//				value = value - cal[0];
				uint32_t prepVal = (uint32_t) (0x00FF << 16) | value;
				HAL_UART_Transmit(&huart4, (uint8_t*) &prepVal, 3, 10);
			}
//			}
			/* Toggle led */
			if (toggle <= 0) {
				HAL_GPIO_TogglePin(LED_1_GPIO_Port, LED_1_Pin);
				toggle = 1000;
			} else {
				toggle--;
			}
		}
		HAL_GPIO_WritePin(LED_1_GPIO_Port, LED_1_Pin, RESET);
		goto start;

//		while (GetSignal(SOE) == TRUE) {
//			if (ADCBitMap == ADCBITMAPDMS) { //All Interrupts appeard!
//				ReadADCs(memoryregion);
//				Counter++;
//				TelCounter++;
//				ADCBitMap = ADCBITMAPNORMAL;
//			}
//			if (Counter == 10) {
//				WriteToMemory(memoryregion);
//				Counter = 0;
//			}
//
//			switch (TelCounter) {
//			case 16: //Prepare frame aks sec. SPU for status
//				//InterSPUSend(); Transmit uwticks to secondary SPU, sec. SPU will respond with status
//				break;
//			case 17: // Send frame
//				//TelemetrySend..
//				TelCounter = 0;
//				break;
//			default:
//				break;
//			}
//
//			if (GetSignal(SODS) == TRUE) {
//				//Set timestamp = 0
//				// SysTick_handler will call HAL_IncTick, which will increment uwTick
//				uwTick = 0;
//			}
//			if (GetSignal(SODS) == FALSE) {
//				//Shutdown
//				WriteToMemory(memoryregion);
//				//WriteMetadata
//				ClearSignal(SOE); // To break the while
//			}
//		}
		if (memoryregion)
			free(memoryregion);
	}
}
