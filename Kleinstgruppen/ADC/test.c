//Versuch eines Testfiles
#include "main.h"

#include "cmsis_os2.h"

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

uint32_t adc_test(void) {

	HAL_StatusTypeDef sende_status[6] = {0,0,0,0,0,0};
	HAL_StatusTypeDef empfangs_status[4] = {0, 0 ,0 ,0};

	uint8_t receiving_test_data [4] = {0,0,0,0,0};
	uint16_t meas_test_values = 0;
	int l = 0;


	sende_status[0] = HAL_SPI_Transmit(&hspi5, &wreg_command[0], 1, 10); // REG Register beschreiben
	sende_status[1] = HAL_SPI_Transmit(&hspi5, &wreg_command[1], 1, 10);
	sende_status[1] = HAL_SPI_Transmit(&hspi5, &wreg_command[2], 1, 10);
	sende_status[3] = HAL_SPI_Transmit(&hspi5, &wreg_command[3], 1, 10);
	sende_status[4] = HAL_SPI_Transmit(&hspi5, &wreg_command[4], 1, 10);
	sende_status[5] = HAL_SPI_Transmit(&hspi5, &wreg_command[5], 1, 10);
	for(int x = 0; x<7; x++){
		if(sende_status[x]!=HAL_OK){
			return 1; //Exit Code für fehlgeschlagenes Senden
		}
	}




	HAL_SPI_Transmit(&hspi5, &readregister[0], 1, 10); // TEST ob WREG ERFolgreich
	HAL_SPI_Transmit(&hspi5, &readregister[1], 1, 10); // TEST ob WREG ERFolgreich

	empfangs_status[0] = HAL_SPI_Receive(&hspi5, &registervalue[0], 1, 20); // TEST ob WREG ERFolgreich
	empfangs_status[1] = HAL_SPI_Receive(&hspi5, &registervalue[1], 1, 20); // TEST ob WREG ERFolgreich
	empfangs_status[2] = HAL_SPI_Receive(&hspi5, &registervalue[2], 1, 20); // TEST ob WREG ERFolgreich
	empfangs_status[3] = HAL_SPI_Receive(&hspi5, &registervalue[3], 1, 20); // TEST ob WREG ERFolgreich

	for (int w = 0 ; w<5; w++){
		if(empfangs_status[w] != HAL_OK){
			return 2; //Exit Code für fehlgeschlagenes Empfangen
		}
	}

	for (int u = 0; u<5; u++){
		if(registervalue[u]!=wreg_command[u]){
			return 3; //Exit Code für falsches Lesen der Register
		}
	}

	/*while(1){
		if(HAL_GPIO_ReadPin(GPIOE, GPIO_PIN_3) == GPIO_PIN_SET){		//
			if(HAL_GPIO_ReadPin(GPIOE, GPIO_PIN_3) == GPIO_PIN_RESET){  //
		}
			HAL_SPI_TransmitReceive(&hspi5, &readdata[0], &receiving_test_data[0], 4, 20);
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


//Ende eines Versuchs eines Testfiles






