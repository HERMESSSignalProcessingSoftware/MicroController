
#include "main.h"

extern SPI_HandleTypeDef *hspi5;

extern uint8_t receivingdata[4];
extern uint8_t readdata[4]; // READ DATA Befehlssatz
extern uint8_t readregister[2]; // READ Register Befehlssatz
extern uint8_t nop[2]; // NOP Befehle
extern uint8_t transmitdata[3]; // READ DATA Befehlssatz und 16 SCLK's
extern uint16_t result[300]; //FANGVARIABLE
extern uint16_t buffer[1];
extern int i;

void HAL_GPIO_EXTI_Callback(uint16_t GPIO_Pin) { // Externer Interrupt Callback

	//uint16_t data[2] = {1,1};
	if (GPIO_Pin == GPIO_PIN_3) {
		//HAL_SPI_Receive(&hspi5, (uint8_t *)&data[0],2,3);
		//HAL_GPIO_WritePin(GPIOE, GPIO_PIN_6, GPIO_PIN_RESET); //START->
		//HAL_GPIO_WritePin(GPIOG, GPIO_PIN_1, GPIO_PIN_SET); // CS deaktiviert DRDY?
		//osEventFlagsSet(DRDY_FLAG_ID, DRDY_FLAG);
		if(i == 0){ // Ansonsten keine WErte auslesbar Ursache noch unklar
			HAL_GPIO_WritePin(GPIOE, GPIO_PIN_2, GPIO_PIN_SET);
			HAL_Delay(25);
			HAL_GPIO_WritePin(GPIOE, GPIO_PIN_2, GPIO_PIN_SET);

		}
		HAL_GPIO_WritePin(GPIOB, GPIO_PIN_7, GPIO_PIN_SET);		//LIcht
		HAL_GPIO_WritePin(GPIOG, GPIO_PIN_1, GPIO_PIN_RESET);		//CS LOW
		HAL_Delay(1);		// Delay
		//HAL_SPI_Receive(&hspi5, (uint8_t *)&receivingdata[0],2,1);//

		HAL_SPI_TransmitReceive(&hspi5, &readdata[0], &receivingdata[0], 4, 20);//Pointer incompatible  WARUM??????????
		HAL_Delay(1);
		HAL_GPIO_WritePin(GPIOG, GPIO_PIN_1, GPIO_PIN_SET); // CS HIGH
		HAL_GPIO_WritePin(GPIOB, GPIO_PIN_7, GPIO_PIN_RESET); // Licht
		if ((i < 301)) {
			result[i] = ((uint16_t) receivingdata[1] << 8) | receivingdata[2]; // Shift Operation LSB und MSB verheiraten

			i++;
		}

	}
}
