/* USER CODE BEGIN Header */
/**
 ******************************************************************************
 @file           : main.c
 @brief          : Main program body
 ******************************************************************************
 @attention

 <h2><center>&copy; Copyright (c) 2020 STMicroelectronics.
 All rights reserved.</center></h2>

 This software component is licensed by ST under BSD 3-Clause license,
 the "License"; You may not use this file except in compliance with the
 License. You may obtain a copy of the License at:
 opensource.org/licenses/BSD-3-Clause

 ******************************************************************************
 */
/* USER CODE END Header */
/* Includes ------------------------------------------------------------------*/
#include "main.h"
#include "crc.h"
#include "spi.h"
#include "usart.h"
#include "gpio.h"
#include "string.h"

/* Private includes ----------------------------------------------------------*/
/* USER CODE BEGIN Includes */
/* USER CODE END Includes */

/* Private typedef -----------------------------------------------------------*/
/* USER CODE BEGIN PTD */

/* USER CODE END PTD */

/* Private define ------------------------------------------------------------*/
/* USER CODE BEGIN PD */
/* USER CODE END PD */

/* Private macro -------------------------------------------------------------*/
/* USER CODE BEGIN PM */

/* USER CODE END PM */

/* Private variables ---------------------------------------------------------*/

/* USER CODE BEGIN PV */

/* USER CODE END PV */

/* Private function prototypes -----------------------------------------------*/
void SystemClock_Config(void);
/* USER CODE BEGIN PFP */

/* USER CODE END PFP */

/* Private user code ---------------------------------------------------------*/
/* USER CODE BEGIN 0 */
uint16_t data = 0;
/* USER CODE END 0 */

/**
 * @brief  The application entry point.
 * @retval int
 */
int main(void) {
	/* USER CODE BEGIN 1 */

	/* USER CODE END 1 */

	/* MCU Configuration--------------------------------------------------------*/

	/* Reset of all peripherals, Initializes the Flash interface and the Systick. */
 	HAL_Init();

	/* USER CODE BEGIN Init */

	/* USER CODE END Init */

	/* Configure the system clock */
	SystemClock_Config();

	/* USER CODE BEGIN SysInit */

	/* USER CODE END SysInit */

	/* Initialize all configured peripherals */
	MX_GPIO_Init();
	MX_SPI2_Init();
	MX_SPI3_Init();
	MX_SPI6_Init();
	MX_UART4_Init();
	MX_UART8_Init();
	MX_UART5_Init();
	MX_CRC_Init();
	MX_SPI4_Init();
	MX_SPI5_Init();
	/* USER CODE BEGIN 2 */
	HAL_GPIO_WritePin(LED_1_GPIO_Port, LED_1_Pin, GPIO_PIN_RESET); //clear all LEDs
	HAL_GPIO_WritePin(LED_2_GPIO_Port, LED_2_Pin, GPIO_PIN_RESET);
	HAL_GPIO_WritePin(LED_3_GPIO_Port, LED_3_Pin, GPIO_PIN_RESET);
	HAL_GPIO_WritePin(LED_4_GPIO_Port, LED_4_Pin, GPIO_PIN_RESET);

	if (!HAL_GPIO_ReadPin(MS_SEL_GPIO_Port, MS_SEL_Pin)) {
		main_master();
	} else { //Slave loop
		main_slave();
	}

	/* USER CODE END 2 */

	/* Infinite loop */
	/* USER CODE BEGIN WHILE */
	while (1) {
		/* USER CODE END WHILE */

		/* USER CODE BEGIN 3 */
	}
	/* USER CODE END 3 */
}

/**
 * @brief System Clock Configuration
 * @retval None
 */
void SystemClock_Config(void) {
	RCC_OscInitTypeDef RCC_OscInitStruct = { 0 };
	RCC_ClkInitTypeDef RCC_ClkInitStruct = { 0 };
	RCC_PeriphCLKInitTypeDef PeriphClkInitStruct = { 0 };

	/** Configure the main internal regulator output voltage
	 */
	__HAL_RCC_PWR_CLK_ENABLE();
	__HAL_PWR_VOLTAGESCALING_CONFIG(PWR_REGULATOR_VOLTAGE_SCALE1);
	/** Initializes the RCC Oscillators according to the specified parameters
	 * in the RCC_OscInitTypeDef structure.
	 */
	RCC_OscInitStruct.OscillatorType = RCC_OSCILLATORTYPE_HSI;
	RCC_OscInitStruct.HSIState = RCC_HSI_ON;
	RCC_OscInitStruct.HSICalibrationValue = RCC_HSICALIBRATION_DEFAULT;
	RCC_OscInitStruct.PLL.PLLState = RCC_PLL_ON;
	RCC_OscInitStruct.PLL.PLLSource = RCC_PLLSOURCE_HSI;
	RCC_OscInitStruct.PLL.PLLM = 8;
	RCC_OscInitStruct.PLL.PLLN = 192;
	RCC_OscInitStruct.PLL.PLLP = RCC_PLLP_DIV2;
	RCC_OscInitStruct.PLL.PLLQ = 2;
	if (HAL_RCC_OscConfig(&RCC_OscInitStruct) != HAL_OK) {
		Error_Handler();
	}
	/** Activate the Over-Drive mode
	 */
	if (HAL_PWREx_EnableOverDrive() != HAL_OK) {
		Error_Handler();
	}
	/** Initializes the CPU, AHB and APB buses clocks
	 */
	RCC_ClkInitStruct.ClockType = RCC_CLOCKTYPE_HCLK | RCC_CLOCKTYPE_SYSCLK
			| RCC_CLOCKTYPE_PCLK1 | RCC_CLOCKTYPE_PCLK2;
	RCC_ClkInitStruct.SYSCLKSource = RCC_SYSCLKSOURCE_PLLCLK;
	RCC_ClkInitStruct.AHBCLKDivider = RCC_SYSCLK_DIV1;
	RCC_ClkInitStruct.APB1CLKDivider = RCC_HCLK_DIV4;
	RCC_ClkInitStruct.APB2CLKDivider = RCC_HCLK_DIV16;

	if (HAL_RCC_ClockConfig(&RCC_ClkInitStruct, FLASH_LATENCY_6) != HAL_OK) {
		Error_Handler();
	}
	PeriphClkInitStruct.PeriphClockSelection = RCC_PERIPHCLK_UART4
			| RCC_PERIPHCLK_UART5 | RCC_PERIPHCLK_UART8;
	PeriphClkInitStruct.Uart4ClockSelection = RCC_UART4CLKSOURCE_PCLK1;
	PeriphClkInitStruct.Uart5ClockSelection = RCC_UART5CLKSOURCE_PCLK1;
	PeriphClkInitStruct.Uart8ClockSelection = RCC_UART8CLKSOURCE_PCLK1;
	if (HAL_RCCEx_PeriphCLKConfig(&PeriphClkInitStruct) != HAL_OK) {
		Error_Handler();
	}
}

/* USER CODE BEGIN 4 */
void main_master(void) {
	//HAL_GPIO_WritePin(LED_1_GPIO_Port, LED_1_Pin, GPIO_PIN_SET);  //ON = MS set to Master
	//uint8_t bufferOff[3] = {0x01, 0x03, 0x05};
	//uint8_t bufferOn[3] = {0x02, 0x04, 0x06};

	uint32_t lastInit = 0;
	uint32_t lastBlinky = 0;
	uint8_t writeBuffer[256] = { 0 };

	uint8_t readSensor = 3; //DMS: 0-5, PT100: 6-8

	/* Performing the memory test */
	InitMemory();
	uint32_t memoryTest = FastMemoryTest();
	sprintf(writeBuffer, " \n\rMemory test: %s\n\r\0",
			(memoryTest == 0 ? "Passed" : "Failed"));
	HAL_UART_Transmit(&huart4, writeBuffer, strlen(writeBuffer), HAL_MAX_DELAY);
	/*For Framerate*/
	HAL_Delay(5000);

	for (int sensors = 0; sensors <= 8; sensors++) {
		if (sensors <= 5)
			adc_scan_start(sensors, 2000, 128, 0);
		else
			adc_scan_start(sensors, 2000, 1, 0);
	}

	HAL_Delay(1000);

	uint8_t softgain = 1;
	uint8_t offset = 0;
	uint8_t dout = 0;
	HAL_UART_Transmit(&huart4, (uint8_t*) &dout, sizeof(dout), HAL_MAX_DELAY);

	while (1) { //Master loop

		data = adc_scan(readSensor, 0x01);
		dout = data * softgain + offset;
		write_DAPI(&dout);
		write_EXP(&dout);

		HAL_GPIO_WritePin(LED_2_GPIO_Port, LED_2_Pin,
				HAL_GPIO_ReadPin(SODS_OPT_GPIO_Port, SODS_OPT_Pin));
		HAL_GPIO_WritePin(LED_3_GPIO_Port, LED_3_Pin,
				HAL_GPIO_ReadPin(LO_OPT_GPIO_Port, LO_OPT_Pin));
		HAL_GPIO_WritePin(LED_4_GPIO_Port, LED_4_Pin,
				HAL_GPIO_ReadPin(SOE_OPT_GPIO_Port, SOE_OPT_Pin));

		if (lastInit + 5000 < HAL_GetTick()) {
			lastInit = HAL_GetTick();
			//write_EXP(&dout);
			/*
			 for(int sensors = 0; sensors <=8 ; sensors++){
			 if(sensors <= 5)
			 adc_scan_start(sensors, 2000, 128, 0);
			 else
			 adc_scan_start(sensors, 20, 1, 50);
			 }
			 */

		}

		if (lastBlinky + 1000 < HAL_GetTick()) {
			lastBlinky = HAL_GetTick();
			HAL_GPIO_TogglePin(LED_1_GPIO_Port, LED_1_Pin);
		}

		/*
		 HAL_GPIO_TogglePin(LED_3_GPIO_Port, LED_3_Pin);
		 HAL_UART_Transmit(&huart5, bufferOff, sizeof(bufferOff), 5);
		 HAL_Delay(100);
		 HAL_GPIO_TogglePin(LED_3_GPIO_Port, LED_3_Pin);
		 HAL_UART_Transmit(&huart5, bufferOn, sizeof(bufferOn), 5);
		 HAL_Delay(100);
		 */
	}
}

void main_slave(void) {
	uint8_t buffer[1] = { 0x00 };
	while (1) {
		HAL_UART_Receive(&huart5, buffer, sizeof(buffer), 5);
		if (buffer[0] == 0x01) {
			HAL_GPIO_WritePin(LED_2_GPIO_Port, LED_2_Pin, GPIO_PIN_RESET);
		} else if (buffer[0] == 0x02) {
			HAL_GPIO_WritePin(LED_2_GPIO_Port, LED_2_Pin, GPIO_PIN_SET);
		} else if (buffer[0] == 0x03) {
			HAL_GPIO_WritePin(LED_3_GPIO_Port, LED_3_Pin, GPIO_PIN_RESET);
		} else if (buffer[0] == 0x04) {
			HAL_GPIO_WritePin(LED_3_GPIO_Port, LED_3_Pin, GPIO_PIN_SET);
		} else if (buffer[0] == 0x05) {
			HAL_GPIO_WritePin(LED_4_GPIO_Port, LED_4_Pin, GPIO_PIN_RESET);
		} else if (buffer[0] == 0x06) {
			HAL_GPIO_WritePin(LED_4_GPIO_Port, LED_4_Pin, GPIO_PIN_SET);
		}
		buffer[1] = 0x00;
	}
}

int cs_enable(int8_t id) {
	HAL_GPIO_WritePin(port_from_id(id), pin_from_id(id), GPIO_PIN_RESET);
	HAL_Delay(1);
	return 0;
}

int cs_disable(int8_t id) {
	HAL_GPIO_WritePin(port_from_id(id), pin_from_id(id), GPIO_PIN_SET);
	HAL_Delay(1);
	return 0;
}

int wr_spi(int8_t id, uint8_t cmd) {
	HAL_SPI_Transmit(get_hspi_from_id(id), &cmd, sizeof(cmd), HAL_MAX_DELAY);
	return 0;
}

uint16_t adc_scan(int8_t id, uint8_t chn) {
	return rd_data(id);
}

int16_t adc_scan_start(int8_t id, uint_least16_t drate, uint_least8_t gain,
		uint_least16_t current) {
	int16_t r = 0;
	switch (drate) {
	case 5:
		drate = SYS0_DOR5;
		break;
	case 10:
		drate = SYS0_DOR10;
		break;
	case 20:
		drate = SYS0_DOR20;
		break;
	default:
	case 40:
		drate = SYS0_DOR40;
		break;
	case 80:
		drate = SYS0_DOR80;
		break;
	case 160:
		drate = SYS0_DOR160;
		break;
	case 320:
		drate = SYS0_DOR320;
		break;
	case 640:
		drate = SYS0_DOR640;
		break;
	case 1000:
		drate = SYS0_DOR1000;
		break;
	case 2000:
		drate = SYS0_DOR2000;
		break;
	}

	switch (gain) {
	default:
	case 1:
		gain = SYS0_PGA1;
		break;
	case 2:
		gain = SYS0_PGA2;
		break;
	case 4:
		gain = SYS0_PGA4;
		break;
	case 8:
		gain = SYS0_PGA8;
		break;
	case 16:
		gain = SYS0_PGA16;
		break;
	case 32:
		gain = SYS0_PGA32;
		break;
	case 64:
		gain = SYS0_PGA64;
		break;
	case 128:
		gain = SYS0_PGA128;
		break;
	}

	switch (current) {
	default:
	case 0:
		current = IDAC0_MAGOFF;
		break;
	case 50:
		current = IDAC0_MAG50UA;
		break;
	case 100:
		current = IDAC0_MAG100UA;
		break;
	case 250:
		current = IDAC0_MAG250UA;
		break;
	case 500:
		current = IDAC0_MAG500UA;
		break;
	case 750:
		current = IDAC0_MAG750UA;
		break;
	case 1000:
		current = IDAC0_MAG1000UA;
		break;
	case 1500:
		current = IDAC0_MAG1500UA;
		break;
	}

	cs_enable(id);

	if (id <= 5) {	//DMS

		wr_cmd(id, CMD_RESET);
		wr_cmd(id, CMD_SDATAC);
		wr_reg(id, REG_MUX0, 0b00000001);
		wr_reg(id, REG_VBIAS, 0x00);
		wr_reg(id, REG_MUX1, 0b00110000);
		wr_reg(id, REG_SYS0, gain | drate);
		wr_reg(id, REG_IDAC0, 0x00);
		wr_reg(id, REG_IDAC1, 0b11001100);
		wr_cmd(id, CMD_SYNC);
		//uint8_t rdata = CMD_RDATAC;
		//HAL_SPI_Transmit(get_hspi_from_id(id), &rdata, 2, HAL_MAX_DELAY);

	} else {	//PT100

		wr_cmd(id, CMD_RESET);
		wr_cmd(id, CMD_SDATAC);
		wr_reg(id, REG_VBIAS, 0x00);
		wr_reg(id, REG_MUX0, 0x01); //?
		wr_reg(id, REG_MUX1, 0b00100000); //int ref on, REFP0/REFN0 ref inp selected
		//wr_reg(id, REG_VBIAS, 0x00);
		//wr_reg(id, REG_MUX1, 0b00110000);
		wr_reg(id, REG_SYS0, gain | drate); //Gain 4, SPS 20
		wr_reg(id, REG_IDAC0, current); //1mA;
		wr_reg(id, REG_IDAC1, 0b00000010); //IDAC1 = AIN0, IDAC2 = AIN3
		wr_cmd(id, CMD_SYNC);
		//uint8_t rdata = CMD_RDATAC;
		//HAL_SPI_Transmit(get_hspi_from_id(id), &rdata, 2, HAL_MAX_DELAY);
	}

	cs_disable(id);

	return r;

}

uint16_t rd_data(int8_t id) {
	uint8_t d1, d3;
	uint16_t dR;

	while (HAL_GPIO_ReadPin(port_drdy_from_id(id), pin_drdy_from_id(id))
			== GPIO_PIN_SET)
		;
	cs_enable(id);

	uint8_t rdata = CMD_RDATA;
	HAL_SPI_Transmit(get_hspi_from_id(id), &rdata, 2, HAL_MAX_DELAY);
	//HAL_Delay(1);

	uint8_t nope = CMD_NOP;
	HAL_SPI_TransmitReceive(get_hspi_from_id(id), &nope, &d1, 2, HAL_MAX_DELAY);
	HAL_SPI_TransmitReceive(get_hspi_from_id(id), &nope, &d3, 2, HAL_MAX_DELAY);
	dR = (d1 << 8) | d3;
	cs_disable(id);

	return dR;
}

//
int rd_spi(int8_t id) {
	uint8_t d1;
	//cs_enable(id);
	HAL_SPI_Receive(get_hspi_from_id(id), &d1, sizeof(d1), HAL_MAX_DELAY);
	//cs_disable(id);
	return d1;
}

//
uint16_t pin_from_id(int8_t id) {
	switch (id) {
	case 0: //DMS 1
		return nCS_DMS1_Pin;
	case 1: //DMS 2
		return nCS_DMS2_Pin;
	case 2: //DMS 3
		return nCS_DMS3_Pin;
	case 3: //DMS 4
		return nCS_DMS4_Pin;
	case 4: //DMS 5
		return nCS_DMS5_Pin;
	case 5: //DMS 6
		return nCS_DMS6_Pin;
	case 6: //PT 1
		return nCS_PT1_Pin;
	case 7: //PT 2
		return nCS_PT2_Pin;
	case 8: //PT 3
		return nCS_PT3_Pin;
	default: //DMS 1
		return nCS_DMS1_Pin;
	}
}

//
GPIO_TypeDef* port_from_id(int8_t id) {
	switch (id) {
	case 0: //DMS 1
		return nCS_DMS1_GPIO_Port;
	case 1: //DMS 2
		return nCS_DMS2_GPIO_Port;
	case 2: //DMS 3
		return nCS_DMS3_GPIO_Port;
	case 3: //DMS 4
		return nCS_DMS4_GPIO_Port;
	case 4: //DMS 5
		return nCS_DMS5_GPIO_Port;
	case 5: //DMS 6
		return nCS_DMS6_GPIO_Port;
	case 6: //PT 1
		return nCS_PT1_GPIO_Port;
	case 7: //PT 2
		return nCS_PT2_GPIO_Port;
	case 8: //PT 3
		return nCS_PT3_GPIO_Port;
	default: //DMS 1
		return nCS_DMS1_GPIO_Port;
	}
}

//
uint16_t pin_drdy_from_id(int8_t id) {
	switch (id) {
	case 0: //DMS 1
		return nDRDY_DMS1_Pin;
	case 1: //DMS 2
		return nDRDY_DMS2_Pin;
	case 2: //DMS 3
		return nDRDY_DMS3_Pin;
	case 3: //DMS 4
		return nDRDY_DMS4_Pin;
	case 4: //DMS 5
		return nDRDY_DMS5_Pin;
	case 5: //DMS 6
		return nDRDY_DMS6_Pin;
	case 6: //PT 1
		return nDRDY_PT1_Pin;
	case 7: //PT 2
		return nDRDY_PT2_Pin;
	case 8: //PT 3
		return nDRDY_PT3_Pin;
	default: //DMS 1
		return nDRDY_DMS1_Pin;
	}
}

//
GPIO_TypeDef* port_drdy_from_id(int8_t id) {
	switch (id) {
	case 0: //DMS 1
		return nDRDY_DMS1_GPIO_Port;
	case 1: //DMS 2
		return nDRDY_DMS2_GPIO_Port;
	case 2: //DMS 3
		return nDRDY_DMS3_GPIO_Port;
	case 3: //DMS 4
		return nDRDY_DMS4_GPIO_Port;
	case 4: //DMS 5
		return nDRDY_DMS5_GPIO_Port;
	case 5: //DMS 6
		return nDRDY_DMS6_GPIO_Port;
	case 6: //PT 1
		return nDRDY_PT1_GPIO_Port;
	case 7: //PT 2
		return nDRDY_PT2_GPIO_Port;
	case 8: //PT 3
		return nDRDY_PT3_GPIO_Port;
	default: //DMS 1
		return nDRDY_DMS1_GPIO_Port;
	}
}

//
SPI_HandleTypeDef* get_hspi_from_id(int8_t id) {
	switch (id) {
	case 0: //DMS 1
		return &hspi4;
	case 1: //DMS 2
		return &hspi4;
	case 2: //DMS 3
		return &hspi4;
	case 3: //DMS 4
		return &hspi4;
	case 4: //DMS 5
		return &hspi4;
	case 5: //DMS 6
		return &hspi4;
	case 6: //PT 1
		return &hspi3;
	case 7: //PT 2
		return &hspi3;
	case 8: //PT 3
		return &hspi3;
	default: //DMS 1
		return &hspi4;
	}
}

//
int wr_cmd(int8_t id, uint8_t cmd) {
	int8_t status = 0;
	//status+= cs_enable(id);
	status += wr_spi(id, cmd);
	if (cmd == CMD_SYNC) {
		status += wr_spi(id, cmd);
	}
	//status+= cs_disable(id);
	if (cmd == CMD_RESET) {
		HAL_Delay(1); //1ms
	} else if (cmd == CMD_SELFOCAL) {
		HAL_Delay(10); //10ms
	} else if (cmd == CMD_SDATAC) {
		HAL_Delay(1); //1ms
	}
	return 0;
}

int wr_reg(int8_t id, uint8_t reg, uint8_t data) {
	int8_t status = 0;
	status += wr_spi(id, CMD_WREG | reg);
	status += wr_spi(id, 0);
	status += wr_spi(id, data);
	return 0;
}

int rd_reg(int8_t id, uint8_t reg) {
	int8_t status = 0;
	uint8_t data;
	//status += cs_enable(id);
	status += wr_spi(id, CMD_RREG | reg);
	status += wr_spi(id, 0);
	data = rd_spi(id);
	//status += cs_disable(id);
	return data;
}

int write_EXP(uint8_t *dout) {
	HAL_UART_Transmit(&huart8, &dout, sizeof(dout), HAL_MAX_DELAY);
	return 0;
}

int write_DAPI(uint8_t *dout) {
	HAL_UART_Transmit(&huart4, &dout, sizeof(dout), HAL_MAX_DELAY);
	return 0;
}

uint8_t* read_DAPI() {
	uint8_t *din;
	HAL_UART_Receive(&huart4, din, 1, HAL_MAX_DELAY);
	return din;
}

/* USER CODE END 4 */

/**
 * @brief  This function is executed in case of error occurrence.
 * @retval None
 */
void Error_Handler(void) {
	/* USER CODE BEGIN Error_Handler_Debug */
	/* User can add his own implementation to report the HAL error return state */

	/* USER CODE END Error_Handler_Debug */
}

#ifdef  USE_FULL_ASSERT
/**
 * @brief  Reports the name of the source file and the source line number
 *         where the assert_param error has occurred.
 * @param  file: pointer to the source file name
 * @param  line: assert_param error line source number
 * @retval None
 */
void assert_failed(uint8_t *file, uint32_t line) {
	/* USER CODE BEGIN 6 */
	/* User can add his own implementation to report the file name and line number,
	 tex: printf("Wrong parameters value: file %s on line %d\r\n", file, line) */
	/* USER CODE END 6 */
}
#endif /* USE_FULL_ASSERT */

/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/
