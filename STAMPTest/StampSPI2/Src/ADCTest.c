/*
 * ADCTest.c
 *
 *  Created on: Jul 3, 2020
 *      Author: Robin Grimsmann
 */

#include "spi.h"
#include "ADCTest.h"

uint32_t adc_test(void) {

	HAL_StatusTypeDef sende_status[6] = { 0, 0, 0, 0, 0, 0 };
	HAL_StatusTypeDef empfangs_status[4] = { 0, 0, 0, 0 };

	uint8_t receiving_test_data[4] = { 0, 0, 0, 0, 0 };
	uint16_t meas_test_values = 0;
	int l = 0;
	// CS Low
	HAL_GPIO_WritePin(nCS_GPIO_Port, nCS_Pin, GPIO_PIN_RESET);

	sende_status[0] = HAL_SPI_Transmit(&hspi3, &wreg_command[0], 1, 20); // REG Register beschreiben WERT: OK
	sende_status[1] = HAL_SPI_Transmit(&hspi3, &wreg_command[1], 1, 20); // WERT: OK
	sende_status[1] = HAL_SPI_Transmit(&hspi3, &wreg_command[2], 1, 20); // WERT: OK
	sende_status[3] = HAL_SPI_Transmit(&hspi3, &wreg_command[3], 1, 20); // WERT: OK
	sende_status[4] = HAL_SPI_Transmit(&hspi3, &wreg_command[4], 1, 20); // WERT: OK
	sende_status[5] = HAL_SPI_Transmit(&hspi3, &wreg_command[5], 1, 20); // WERT: OK
	for (int x = 0; x < 7; x++) {
		if (sende_status[x] != HAL_OK) {
			return 1; //Exit Code für fehlgeschlagenes Senden
		}
	}

	uint8_t rreg[2] = {0x20, 0x03};
	uint8_t nopp[6] = {0xFF, 0xFF, 0xFF, 0xFF, 0xff, 0xff};
	uint8_t emp[6] = {0x00};
	HAL_SPI_Transmit(&hspi3, &readregister[0], 1, 20); // TEST ob WREG ERFolgreich WERT: OK
	HAL_SPI_Transmit(&hspi3, &readregister[1], 1, 20); // TEST ob WREG ERFolgreich WERT: OK
	//HAL_SPI_Transmit(&hspi3, rreg, 2, 20); // transmit command and number of regs

	empfangs_status[0] = HAL_SPI_Receive(&hspi3, &registervalue[0], 1, 20); // TEST ob WREG ERFolgreich
	empfangs_status[1] = HAL_SPI_Receive(&hspi3, &registervalue[1], 1, 20); // TEST ob WREG ERFolgreich
	empfangs_status[2] = HAL_SPI_Receive(&hspi3, &registervalue[2], 1, 20); // TEST ob WREG ERFolgreich
	empfangs_status[3] = HAL_SPI_Receive(&hspi3, &registervalue[3], 1, 20); // TEST ob WREG ERFolgreich

	//empfangs_status[0] = HAL_SPI_TransmitReceive(&hspi3, nopp, emp, 6, 20);
	for (int w = 0; w < 5; w++) {
		if (empfangs_status[w] != HAL_OK) {
			return 2; //Exit Code für fehlgeschlagenes Empfangen
		}
	}

	for (int u = 0; u < 4; u++) {
		if (registervalue[u] != wreg_command[2 + u]) {
			return 3; //Exit Code für falsches Lesen der Register
		}
	}

	HAL_GPIO_WritePin(nCS_GPIO_Port, nCS_Pin, GPIO_PIN_SET);
	/*while(1){
	 if(HAL_GPIO_ReadPin(GPIOE, GPIO_PIN_3) == GPIO_PIN_SET){		//
	 if(HAL_GPIO_ReadPin(GPIOE, GPIO_PIN_3) == GPIO_PIN_RESET){  //
	 }
	 HAL_SPI_TransmitReceive(&hspi3, &readdata[0], &receiving_test_data[0], 4, 20);
	 meas_test_values = (((uint16_t) receiving_test_data[1] << 8) | receiving_test_data[2]);
	 if	(meas_test_values == 0x0){
	 return 4; //Exit Code für 0 Messwert
	 }
	 if(meas_test_values == 0xff){
	 return 5; //Exit Code für maximalen Messwert
	 }
	 }
	 }*/

	return 0; //Test war erfolgreich

}

