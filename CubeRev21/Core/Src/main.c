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
int main(void)
{
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
  MX_SPI4_Init();
  MX_UART4_Init();
  MX_SPI2_Init();
  MX_SPI3_Init();
  MX_SPI6_Init();
  MX_UART8_Init();
  MX_UART5_Init();
  MX_CRC_Init();
  MX_SPI5_Init();
  /* USER CODE BEGIN 2 */
  HAL_GPIO_WritePin(LED_1_GPIO_Port, LED_1_Pin, GPIO_PIN_RESET);  //clear all LEDs
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
  while (1)
  {
    /* USER CODE END WHILE */

    /* USER CODE BEGIN 3 */
  }
  /* USER CODE END 3 */
}

/**
  * @brief System Clock Configuration
  * @retval None
  */
void SystemClock_Config(void)
{
  RCC_OscInitTypeDef RCC_OscInitStruct = {0};
  RCC_ClkInitTypeDef RCC_ClkInitStruct = {0};
  RCC_PeriphCLKInitTypeDef PeriphClkInitStruct = {0};

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
  if (HAL_RCC_OscConfig(&RCC_OscInitStruct) != HAL_OK)
  {
    Error_Handler();
  }
  /** Activate the Over-Drive mode
  */
  if (HAL_PWREx_EnableOverDrive() != HAL_OK)
  {
    Error_Handler();
  }
  /** Initializes the CPU, AHB and APB buses clocks
  */
  RCC_ClkInitStruct.ClockType = RCC_CLOCKTYPE_HCLK|RCC_CLOCKTYPE_SYSCLK
                              |RCC_CLOCKTYPE_PCLK1|RCC_CLOCKTYPE_PCLK2;
  RCC_ClkInitStruct.SYSCLKSource = RCC_SYSCLKSOURCE_PLLCLK;
  RCC_ClkInitStruct.AHBCLKDivider = RCC_SYSCLK_DIV1;
  RCC_ClkInitStruct.APB1CLKDivider = RCC_HCLK_DIV4;
  RCC_ClkInitStruct.APB2CLKDivider = RCC_HCLK_DIV16;

  if (HAL_RCC_ClockConfig(&RCC_ClkInitStruct, FLASH_LATENCY_6) != HAL_OK)
  {
    Error_Handler();
  }
  PeriphClkInitStruct.PeriphClockSelection = RCC_PERIPHCLK_UART4|RCC_PERIPHCLK_UART5
                              |RCC_PERIPHCLK_UART8;
  PeriphClkInitStruct.Uart4ClockSelection = RCC_UART4CLKSOURCE_PCLK1;
  PeriphClkInitStruct.Uart5ClockSelection = RCC_UART5CLKSOURCE_PCLK1;
  PeriphClkInitStruct.Uart8ClockSelection = RCC_UART8CLKSOURCE_PCLK1;
  if (HAL_RCCEx_PeriphCLKConfig(&PeriphClkInitStruct) != HAL_OK)
  {
    Error_Handler();
  }
}

/* USER CODE BEGIN 4 */
void main_master(void) {
  HAL_GPIO_WritePin(LED_1_GPIO_Port, LED_1_Pin, GPIO_PIN_SET);  //ON = MS set to Master
  //uint8_t bufferOff[3] = {0x01, 0x03, 0x05};
  //uint8_t bufferOn[3] = {0x02, 0x04, 0x06};

  adc_scan_start(3, 160, 1, 0);
  HAL_Delay(1000);


  while (1) { //Master loop

	  while(HAL_GPIO_ReadPin(nDRDY_DMS4_GPIO_Port, nDRDY_DMS4_Pin) == GPIO_PIN_SET);
	  data = adc_scan(3, 0x01);
	  HAL_UART_Transmit(&huart4, data, sizeof(&data), 5);

	  HAL_Delay(100);
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
  uint8_t buffer[1] = {0x00};
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
    }  else if (buffer[0] == 0x05) {
      HAL_GPIO_WritePin(LED_4_GPIO_Port, LED_4_Pin, GPIO_PIN_RESET);
    } else if (buffer[0] == 0x06) {
      HAL_GPIO_WritePin(LED_4_GPIO_Port, LED_4_Pin, GPIO_PIN_SET);
    }
    buffer[1] = 0x00;
  }
}

int cs_enable(int8_t id){
	HAL_GPIO_WritePin(port_from_id(id), pin_from_id(id), GPIO_PIN_RESET);
	return 0;
}

int cs_disable(int8_t id){
	HAL_GPIO_WritePin(port_from_id(id), pin_from_id(id), GPIO_PIN_SET);
	return 0;
}

int wr_spi(int8_t id, uint8_t cmd){
	HAL_SPI_Transmit(get_hspi_from_id(id), &cmd, sizeof(cmd), HAL_MAX_DELAY);
	return 0;
}

uint16_t adc_scan(int8_t id, uint8_t chn){
	uint16_t data=0;

	  switch(chn)
	  {
	    case 0x01:
	      wr_reg(id, REG_IDAC1, IDAC1_I1DIR0 | IDAC1_I2DIR1);
	      wr_reg(id, REG_MUX0, MUX0_SP0 | MUX0_SN1);
	      data = rd_data(id);
	      wr_reg(id, REG_IDAC1, IDAC1_I1DIROFF | IDAC1_I2DIROFF);
	      break;
	    case 0x23:
	      wr_reg(id, REG_IDAC1, IDAC1_I1DIR2 | IDAC1_I2DIR3);
	      wr_reg(id, REG_MUX0, MUX0_SP2 | MUX0_SN3);
	      data = rd_data(id);
	      wr_reg(id, REG_IDAC1, IDAC1_I1DIROFF | IDAC1_I2DIROFF);
	      break;

	    case 0xF9: //offset measurement
	      wr_reg(id, REG_MUX1, MUX1_INTOSC | MUX1_INTREFON | MUX1_REFOB | MUX1_CALOFFSET);
	      data = rd_data(id);
	      wr_reg(id, REG_MUX1, MUX1_INTOSC | MUX1_INTREFON | MUX1_REF0 | MUX1_CALNORMAL);
	      break;
	    case 0xFA: //gain measurement
	      wr_reg(id, REG_MUX1, MUX1_INTOSC | MUX1_INTREFON | MUX1_REFOB | MUX1_CALGAIN);
	      data = rd_data(id);
	      wr_reg(id, REG_MUX1, MUX1_INTOSC | MUX1_INTREFON | MUX1_REF0 | MUX1_CALNORMAL);
	      break;
	    case 0xFB: //temperature measurement
	      wr_reg(id, REG_MUX1, MUX1_INTOSC | MUX1_INTREFON | MUX1_REFOB | MUX1_CALTEMP);
	      data = rd_data(id);
	      wr_reg(id, REG_MUX1, MUX1_INTOSC | MUX1_INTREFON | MUX1_REF0 | MUX1_CALNORMAL);
	      break;
	    case 0xFC: //REF1 measurement
	      wr_reg(id, REG_IDAC1, IDAC1_I1DIR0 | IDAC1_I2DIR1);
	      wr_reg(id, REG_MUX1, MUX1_INTOSC | MUX1_INTREFON | MUX1_REFOB | MUX1_CALREF1);
	      data = rd_data(id);
	      wr_reg(id, REG_MUX1, MUX1_INTOSC | MUX1_INTREFON | MUX1_REF0 | MUX1_CALNORMAL);
	      wr_reg(id, REG_IDAC1, IDAC1_I1DIROFF | IDAC1_I2DIROFF);
	      break;
	    case 0xFD: //REF0 measurement
	      wr_reg(id, REG_IDAC1, IDAC1_I1DIR0 | IDAC1_I2DIR1);
	      wr_reg(id, REG_MUX1, MUX1_INTOSC | MUX1_INTREFON | MUX1_REFOB | MUX1_CALREF0);
	      data = rd_data(id);
	      wr_reg(id, REG_MUX1, MUX1_INTOSC | MUX1_INTREFON | MUX1_REF0 | MUX1_CALNORMAL);
	      wr_reg(id, REG_IDAC1, IDAC1_I1DIROFF | IDAC1_I2DIROFF);
	      break;
	    case 0xFE: //AVDD measurement
	      wr_reg(id, REG_MUX1, MUX1_INTOSC | MUX1_INTREFON | MUX1_REFOB | MUX1_CALAVDD);
	      data = rd_data(id);
	      wr_reg(id, REG_MUX1, MUX1_INTOSC | MUX1_INTREFON | MUX1_REF0 | MUX1_CALNORMAL);
	      break;
	    case 0xFF: //DVDD measurement
	      wr_reg(id, REG_MUX1, MUX1_INTOSC | MUX1_INTREFON | MUX1_REFOB | MUX1_CALDVDD);
	      data = rd_data(id);
	      wr_reg(id, REG_MUX1, MUX1_INTOSC | MUX1_INTREFON | MUX1_REF0 | MUX1_CALNORMAL);
	      break;
	  }

	  return data;
}

int16_t adc_scan_start(int8_t id, uint_least16_t drate, uint_least8_t gain, uint_least16_t current){
	int16_t r;
	switch(drate)
	  {
	    case    5: drate = SYS0_DOR5;    break;
	    case   10: drate = SYS0_DOR10;   break;
	    case   20: drate = SYS0_DOR20;   break;
	    default:
	    case   40: drate = SYS0_DOR40;   break;
	    case   80: drate = SYS0_DOR80;   break;
	    case  160: drate = SYS0_DOR160;  break;
	    case  320: drate = SYS0_DOR320;  break;
	    case  640: drate = SYS0_DOR640;  break;
	    case 1000: drate = SYS0_DOR1000; break;
	    case 2000: drate = SYS0_DOR2000; break;
	  }

	  switch(gain)
	  {
	    default:
	    case   1: gain = SYS0_PGA1;   break;
	    case   2: gain = SYS0_PGA2;   break;
	    case   4: gain = SYS0_PGA4;   break;
	    case   8: gain = SYS0_PGA8;   break;
	    case  16: gain = SYS0_PGA16;  break;
	    case  32: gain = SYS0_PGA32;  break;
	    case  64: gain = SYS0_PGA64;  break;
	    case 128: gain = SYS0_PGA128; break;
	  }

	  switch(current)
	  {
	    default:
	    case    0: current = IDAC0_MAGOFF;    break;
	    case   50: current = IDAC0_MAG50UA;   break;
	    case  100: current = IDAC0_MAG100UA;  break;
	    case  250: current = IDAC0_MAG250UA;  break;
	    case  500: current = IDAC0_MAG500UA;  break;
	    case  750: current = IDAC0_MAG750UA;  break;
	    case 1000: current = IDAC0_MAG1000UA; break;
	    case 1500: current = IDAC0_MAG1500UA; break;
	  }

	  wr_cmd(id, CMD_RESET);
	  wr_cmd(id, CMD_SELFOCAL);
	  r = (rd_reg(id, REG_IDAC0)&0xF0)>>4; //read revision
	  wr_reg(id, REG_MUX0, MUX0_BCSOFF | MUX0_SP0 | MUX0_SN1);
	  wr_reg(id, REG_VBIAS, VBIAS_OFF);
	  wr_reg(id, REG_MUX1, MUX1_INTOSC | MUX1_INTREFON | MUX1_REF0 | MUX1_CALNORMAL);
	  wr_reg(id, REG_SYS0, gain | drate);
	  wr_reg(id, REG_IDAC0, IDAC0_DOUTDRDY | current);
	  wr_reg(id, REG_IDAC1, IDAC1_I1DIROFF | IDAC1_I2DIROFF);

	  return r;

}

uint16_t rd_data(int8_t id){
	uint8_t d1, d2;
	wr_cmd(id, CMD_SYNC);
	cs_enable(id);
	HAL_Delay(1);
	HAL_SPI_Receive(get_hspi_from_id(id), &d1, sizeof(d1), HAL_MAX_DELAY);
	//HAL_SPI_Receive(get_hspi_from_id(id), &d2, sizeof(d1), HAL_MAX_DELAY);
	HAL_Delay(1);
	cs_disable(id);
	return d1;
	//int16_t out = (d1+d2)/2UL;
	//return out;
}

int rd_spi(int8_t id){
	uint8_t d1;
	cs_enable(id);
	HAL_Delay(1);
	HAL_SPI_Receive(get_hspi_from_id(id), &d1, sizeof(d1), HAL_MAX_DELAY);
	HAL_Delay(1);
	cs_disable(id);
	return d1;
}

uint16_t pin_from_id(int8_t id){
	switch(id){
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

GPIO_TypeDef* port_from_id(int8_t id){
	switch(id){
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

SPI_HandleTypeDef *get_hspi_from_id(int8_t id){
	switch(id){
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



int wr_cmd(int8_t id, uint8_t cmd){
	int8_t status = 0;
	status+= cs_enable(id);
	HAL_Delay(1);
	status+= wr_spi(id, cmd);
	if(cmd == CMD_SYNC)
	{
		status+= wr_spi(id, cmd);
    }
	status+= cs_disable(id);
	if(cmd == CMD_RESET)
	{
		HAL_Delay(1); //1ms
	}
	else if(cmd == CMD_SELFOCAL)
	{
		HAL_Delay(10); //10ms
	}
	return 0;
}

int wr_reg(int8_t id, uint8_t reg, uint8_t data){
	int8_t status = 0;
	status += cs_enable(id);
	HAL_Delay(1);
	status += wr_spi(id, CMD_WREG | reg);
	status += wr_spi(id, 0);
	status += wr_spi(id, data);
	HAL_Delay(1);
	status += cs_disable(id);
	return 0;
}

int rd_reg(int8_t id, uint8_t reg){
	int8_t status = 0;
	uint8_t data;
	status += cs_enable(id);
	HAL_Delay(1);
	status += wr_spi(id, CMD_RREG | reg);
	status += wr_spi(id, 0);
	data = rd_spi(id);
	HAL_Delay(1);
	status += cs_disable(id);
	return data;
}

/* USER CODE END 4 */

/**
  * @brief  This function is executed in case of error occurrence.
  * @retval None
  */
void Error_Handler(void)
{
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
void assert_failed(uint8_t *file, uint32_t line)
{
  /* USER CODE BEGIN 6 */
  /* User can add his own implementation to report the file name and line number,
     tex: printf("Wrong parameters value: file %s on line %d\r\n", file, line) */
  /* USER CODE END 6 */
}
#endif /* USE_FULL_ASSERT */

/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/
