/**
  ******************************************************************************
  * File Name          : SPI.c
  * Description        : This file provides code for the configuration
  *                      of the SPI instances.
  ******************************************************************************
  * @attention
  *
  * <h2><center>&copy; Copyright (c) 2020 STMicroelectronics.
  * All rights reserved.</center></h2>
  *
  * This software component is licensed by ST under Ultimate Liberty license
  * SLA0044, the "License"; You may not use this file except in compliance with
  * the License. You may obtain a copy of the License at:
  *                             www.st.com/SLA0044
  *
  ******************************************************************************
  */

/* Includes ------------------------------------------------------------------*/
#include "spi.h"

/* USER CODE BEGIN 0 */
#include "ADCTest.h"
/*Below defined in ADCTest.h*/
//extern uint8_t receivingdata[4];
//extern uint8_t readdata[4]; // READ DATA Befehlssatz
//extern uint8_t readregister[2]; // READ Register Befehlssatz
//extern uint8_t nop[2]; // NOP Befehle
//extern uint8_t transmitdata[3]; // READ DATA Befehlssatz und 16 SCLK's
//extern uint16_t result[300]; //FANGVARIABLE
//extern int i;
//extern uint8_t registervalue[6]; //ERGEBNIS des Registers
//extern uint8_t reset_command[1];
//extern uint8_t sdatac_command[1];
//extern uint8_t wreg_command[6]; //BCS -> RESET dann CHANNEL ANX0 auswahl
//extern uint8_t sync_command[1];
//extern uint16_t buffer[1];
/* USER CODE END 0 */

SPI_HandleTypeDef hspi3;

/* SPI3 init function */
void MX_SPI3_Init(void)
{

  hspi3.Instance = SPI3;
  hspi3.Init.Mode = SPI_MODE_MASTER;
  hspi3.Init.Direction = SPI_DIRECTION_2LINES;
  hspi3.Init.DataSize = SPI_DATASIZE_8BIT;
  hspi3.Init.CLKPolarity = SPI_POLARITY_HIGH;
  hspi3.Init.CLKPhase = SPI_PHASE_1EDGE;
  hspi3.Init.NSS = SPI_NSS_SOFT;
  hspi3.Init.BaudRatePrescaler = SPI_BAUDRATEPRESCALER_2;
  hspi3.Init.FirstBit = SPI_FIRSTBIT_MSB;
  hspi3.Init.TIMode = SPI_TIMODE_DISABLE;
  hspi3.Init.CRCCalculation = SPI_CRCCALCULATION_DISABLE;
  hspi3.Init.CRCPolynomial = 7;
  hspi3.Init.CRCLength = SPI_CRC_LENGTH_DATASIZE;
  hspi3.Init.NSSPMode = SPI_NSS_PULSE_ENABLE;
  if (HAL_SPI_Init(&hspi3) != HAL_OK)
  {
    Error_Handler();
  }

}

void HAL_SPI_MspInit(SPI_HandleTypeDef* spiHandle)
{

  GPIO_InitTypeDef GPIO_InitStruct = {0};
  if(spiHandle->Instance==SPI3)
  {
  /* USER CODE BEGIN SPI3_MspInit 0 */

  /* USER CODE END SPI3_MspInit 0 */
    /* SPI3 clock enable */
    __HAL_RCC_SPI3_CLK_ENABLE();
  
    __HAL_RCC_GPIOC_CLK_ENABLE();
    /**SPI3 GPIO Configuration    
    PC10     ------> SPI3_SCK
    PC11     ------> SPI3_MISO
    PC12     ------> SPI3_MOSI 
    */
    GPIO_InitStruct.Pin = GPIO_PIN_10|GPIO_PIN_11|GPIO_PIN_12;
    GPIO_InitStruct.Mode = GPIO_MODE_AF_PP;
    GPIO_InitStruct.Pull = GPIO_NOPULL;
    GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_HIGH;
    GPIO_InitStruct.Alternate = GPIO_AF6_SPI3;
    HAL_GPIO_Init(GPIOC, &GPIO_InitStruct);

    /* SPI3 interrupt Init */
    HAL_NVIC_SetPriority(SPI3_IRQn, 5, 0);
    HAL_NVIC_EnableIRQ(SPI3_IRQn);
  /* USER CODE BEGIN SPI3_MspInit 1 */

  /* USER CODE END SPI3_MspInit 1 */
  }
}

void HAL_SPI_MspDeInit(SPI_HandleTypeDef* spiHandle)
{

  if(spiHandle->Instance==SPI3)
  {
  /* USER CODE BEGIN SPI3_MspDeInit 0 */

  /* USER CODE END SPI3_MspDeInit 0 */
    /* Peripheral clock disable */
    __HAL_RCC_SPI3_CLK_DISABLE();
  
    /**SPI3 GPIO Configuration    
    PC10     ------> SPI3_SCK
    PC11     ------> SPI3_MISO
    PC12     ------> SPI3_MOSI 
    */
    HAL_GPIO_DeInit(GPIOC, GPIO_PIN_10|GPIO_PIN_11|GPIO_PIN_12);

    /* SPI3 interrupt Deinit */
    HAL_NVIC_DisableIRQ(SPI3_IRQn);
  /* USER CODE BEGIN SPI3_MspDeInit 1 */

  /* USER CODE END SPI3_MspDeInit 1 */
  }
} 

/* USER CODE BEGIN 1 */

void init_adc(void) {
	/*Disable interrupt*/
	HAL_NVIC_DisableIRQ(EXTI15_10_IRQn);
	HAL_GPIO_WritePin(nRES_GPIO_Port, nRES_Pin, GPIO_PIN_SET); //Reset auf 1 setzen
	//POwer UP
	HAL_Delay(16);
	HAL_GPIO_WritePin(START_GPIO_Port, START_Pin, GPIO_PIN_SET); // START  HIGH
	HAL_GPIO_WritePin(nCS_GPIO_Port, nCS_Pin, GPIO_PIN_RESET); //  CS  LOW
	HAL_Delay(2);
	HAL_SPI_Transmit(&hspi3, &reset_command[0], 1, 10); // RESET
	HAL_Delay(1);
	HAL_SPI_Transmit(&hspi3, &sdatac_command[0], 1, 10); //STOP READ DATA CONTIN MODE
	HAL_SPI_Transmit(&hspi3, &wreg_command[0], 1, 10); // REG Register beschreiben
	HAL_SPI_Transmit(&hspi3, &wreg_command[1], 1, 10);
	HAL_SPI_Transmit(&hspi3, &wreg_command[2], 1, 10);
	HAL_SPI_Transmit(&hspi3, &wreg_command[3], 1, 10);
	HAL_SPI_Transmit(&hspi3, &wreg_command[4], 1, 10);
	HAL_SPI_Transmit(&hspi3, &wreg_command[5], 1, 10);

	/*Do self calibration*/
	HAL_SPI_Transmit(&hspi3, &selfocal, 1, 10);
	HAL_Delay(9); /* According to datasheet page 33 table 13 */

	HAL_SPI_Transmit(&hspi3, &readregister[0], 1, 10); // TEST ob WREG ERFolgreich
	HAL_SPI_Transmit(&hspi3, &readregister[1], 1, 10); // TEST ob WREG ERFolgreich

	HAL_SPI_Receive(&hspi3, &registervalue[0], 1, 20); // TEST ob WREG ERFolgreich
	HAL_SPI_Receive(&hspi3, &registervalue[1], 1, 20); // TEST ob WREG ERFolgreich
	HAL_SPI_Receive(&hspi3, &registervalue[2], 1, 20); // TEST ob WREG ERFolgreich
	HAL_SPI_Receive(&hspi3, &registervalue[3], 1, 20); // TEST ob WREG ERFolgreich

	HAL_GPIO_WritePin(nRES_GPIO_Port, nRES_Pin, GPIO_PIN_RESET);
	HAL_Delay(10);
	HAL_GPIO_WritePin(nRES_GPIO_Port, nRES_Pin, GPIO_PIN_SET);

	HAL_SPI_Transmit(&hspi3, &readregister[0], 1, 10); // TEST ob WREG ERFolgreich
	HAL_SPI_Transmit(&hspi3, &readregister[1], 1, 10); // TEST ob WREG ERFolgreich

	HAL_SPI_Receive(&hspi3, &registervalue[0], 1, 20); // TEST ob WREG ERFolgreich
	HAL_SPI_Receive(&hspi3, &registervalue[1], 1, 20); // TEST ob WREG ERFolgreich
	HAL_SPI_Receive(&hspi3, &registervalue[2], 1, 20); // TEST ob WREG ERFolgreich
	HAL_SPI_Receive(&hspi3, &registervalue[3], 1, 20); // TEST ob WREG ERFolgreich

	HAL_SPI_Transmit(&hspi3, &sync_command[0], 1, 20); // SYNC
	HAL_Delay(2);
	HAL_GPIO_WritePin(nCS_GPIO_Port, nCS_Pin, GPIO_PIN_SET); //  CS -> HIGH

	//Testfunktion
	uint32_t test_variable = adc_test();
	while (test_variable != 0) {
		HAL_GPIO_WritePin(nRES_GPIO_Port, nRES_Pin, GPIO_PIN_RESET); //kurzer Reset
		HAL_GPIO_WritePin(nRES_GPIO_Port, nRES_Pin, GPIO_PIN_SET); //Rest vorbei
		HAL_GPIO_WritePin(START_GPIO_Port, START_Pin, GPIO_PIN_RESET); // START  low (neustart)
		HAL_GPIO_WritePin(START_GPIO_Port, START_Pin, GPIO_PIN_SET); // START  HIGH (neustart vorbei)
		HAL_GPIO_WritePin(nCS_GPIO_Port, nCS_Pin, GPIO_PIN_SET); //  CS  (CS neusetzen aus spaß haha xd)
		HAL_GPIO_WritePin(nCS_GPIO_Port, nCS_Pin, GPIO_PIN_RESET); //  CS  LOW (SPI ist wieder da)

	}
// Wait for DRDY to transition low // um INIT durchführen zu können -> ohne Interrupt Unterbrechung
	HAL_NVIC_SetPriority(EXTI15_10_IRQn, 6, 0);
	HAL_NVIC_EnableIRQ(EXTI15_10_IRQn);

}

/* USER CODE END 1 */

/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/
