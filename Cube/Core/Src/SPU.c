/*
 * SPU.c
 *
 *  Created on: Aug 7, 2020
 *      Author: Robin Grimsmann
 */

#include <SPU.h>
#include "usart.h"
#include <stdlib.h>

Config_t config = { 0 };

/**
 * ADC Look Up Table
 */
uint8_t ADCLookup[NUMBER_OF_PINS] = { 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF,
		0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0xFF, 0xFF, 0xFF };

/**
 * ADC bitmap
 * default value: 0xFFFFFFFF
 */
uint32_t ADCBitMap = 0xFFFFFFFF;

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
		InitADC();
		void *memoryregion = malloc(256);
		uint32_t Counter = 0;
		uint32_t TelCounter = 0; //Saves the current value of the passed
		while (GetSignal(SOE) == FALSE) { //Stay at state init as long as no signal SOE was set
			//Do nothing
		}
		StartADC(); //Interrups will be coming state changes to data handling
		while (GetSignal(SOE) == TRUE) {
			if (ADCBitMap == ADCBITMAPDMS) { //All Interrupts appeard!
				ReadADCs(memoryregion);
				Counter++;
				ADCBitMap = ADCBITMAPNORMAL;
			}
			if (Counter == 10) {
				WriteToMemory(memoryregion);
				Counter = 0;
			}

			if (TelCounter == 17) {
				// Send Telemetry frame
			}

			if (GetSignal(SODS) == TRUE) {
				//Set timestamp = 0
			}
			if (GetSignal(SODS) == FALSE) {
				//Shutdown
				WriteToMemory(memoryregion);
				//WriteMetadata
				ClearSignal(SOE); // To break the while
			}
		}
		if (memoryregion)
			free(memoryregion);
	}
}
