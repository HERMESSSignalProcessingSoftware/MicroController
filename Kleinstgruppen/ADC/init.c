#include "main.h"
//#include "test.h"

extern SPI_HandleTypeDef hspi5;
extern uint8_t receivingdata[4];
extern uint8_t readdata[3]; // READ DATA Befehlssatz
extern uint8_t readregister[2]; // READ Register Befehlssatz
extern uint8_t nop[2]; // NOP Befehle
extern uint8_t transmitdata[3]; // READ DATA Befehlssatz und 16 SCLK's
extern uint16_t result[300]; //FANGVARIABLE
extern uint8_t registervalue[6]; //ERGEBNIS des Registers
extern uint8_t reset_command[1];
extern uint8_t sdatac_command[1];
extern uint8_t wreg_command[6]; //BCS -> RESET dann CHANNEL ANX0 auswahl
extern uint8_t sync_command[1];
extern int i;
uint32_t test_variable = 0;

extern uint32_t adc_test(void);

void init_adc(void) {

	HAL_GPIO_WritePin(GPIOE, GPIO_PIN_2, GPIO_PIN_SET); //Reset auf 1 setzen
	//POwer UP
	HAL_Delay(16);
	HAL_GPIO_WritePin(GPIOE, GPIO_PIN_6, GPIO_PIN_SET); // START  HIGH
	HAL_GPIO_WritePin(GPIOG, GPIO_PIN_1, GPIO_PIN_RESET); //  CS  LOW
	HAL_Delay(2);
	HAL_SPI_Transmit(&hspi5, &reset_command[0], 1, 10); // RESET
	HAL_Delay(1);
	HAL_SPI_Transmit(&hspi5, &sdatac_command[0], 1, 10); //STOP READ DATA CONTIN MODE
	HAL_SPI_Transmit(&hspi5, &wreg_command[0], 1, 10); // REG Register beschreiben
	HAL_SPI_Transmit(&hspi5, &wreg_command[1], 1, 10);
	HAL_SPI_Transmit(&hspi5, &wreg_command[2], 1, 10);
	HAL_SPI_Transmit(&hspi5, &wreg_command[3], 1, 10);
	HAL_SPI_Transmit(&hspi5, &wreg_command[4], 1, 10);
	HAL_SPI_Transmit(&hspi5, &wreg_command[5], 1, 10);

	HAL_SPI_Transmit(&hspi5, &readregister[0], 1, 10); // TEST ob WREG ERFolgreich
	HAL_SPI_Transmit(&hspi5, &readregister[1], 1, 10); // TEST ob WREG ERFolgreich

	HAL_SPI_Receive(&hspi5, &registervalue[0], 1, 20); // TEST ob WREG ERFolgreich
	HAL_SPI_Receive(&hspi5, &registervalue[1], 1, 20); // TEST ob WREG ERFolgreich
	HAL_SPI_Receive(&hspi5, &registervalue[2], 1, 20); // TEST ob WREG ERFolgreich
	HAL_SPI_Receive(&hspi5, &registervalue[3], 1, 20); // TEST ob WREG ERFolgreich

	HAL_GPIO_WritePin(GPIOE, GPIO_PIN_2, GPIO_PIN_RESET);
	HAL_Delay(10);
	HAL_GPIO_WritePin(GPIOE, GPIO_PIN_2, GPIO_PIN_SET);

	HAL_SPI_Transmit(&hspi5, &readregister[0], 1, 10); // TEST ob WREG ERFolgreich
	HAL_SPI_Transmit(&hspi5, &readregister[1], 1, 10); // TEST ob WREG ERFolgreich

	HAL_SPI_Receive(&hspi5, &registervalue[0], 1, 20); // TEST ob WREG ERFolgreich
	HAL_SPI_Receive(&hspi5, &registervalue[1], 1, 20); // TEST ob WREG ERFolgreich
	HAL_SPI_Receive(&hspi5, &registervalue[2], 1, 20); // TEST ob WREG ERFolgreich
	HAL_SPI_Receive(&hspi5, &registervalue[3], 1, 20); // TEST ob WREG ERFolgreich

	HAL_SPI_Transmit(&hspi5, &sync_command[0], 1, 20); // SYNC
	HAL_Delay(2);
	HAL_GPIO_WritePin(GPIOG, GPIO_PIN_1, GPIO_PIN_SET); //  CS -> HIGH

	//Testfunktion
	test_variable = adc_test();
	while(test_variable != 0){
		HAL_GPIO_WritePin(GPIOE, GPIO_PIN_2, GPIO_PIN_RESET); //kurzer Reset
		HAL_GPIO_WritePin(GPIOE, GPIO_PIN_2, GPIO_PIN_SET); //Rest vorbei
		HAL_GPIO_WritePin(GPIOE, GPIO_PIN_6, GPIO_PIN_RESET); // START  low (neustart)
		HAL_GPIO_WritePin(GPIOE, GPIO_PIN_6, GPIO_PIN_SET); // START  HIGH (neustart vorbei)
		HAL_GPIO_WritePin(GPIOG, GPIO_PIN_1, GPIO_PIN_SET); //  CS  (CS neusetzen aus spaß haha xd)
		HAL_GPIO_WritePin(GPIOG, GPIO_PIN_1, GPIO_PIN_RESET); //  CS  LOW (SPI ist wieder da)

	}


// Wait for DRDY to transition low // um INIT durchführen zu können -> ohne Interrupt Unterbrechung
	HAL_NVIC_SetPriority(EXTI3_IRQn, 6, 0);
	HAL_NVIC_EnableIRQ(EXTI3_IRQn);

}
