/* USER CODE BEGIN Header */
/**
 ******************************************************************************
 * File Name          : freertos.c
 * Description        : Code for freertos applications
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
/* USER CODE END Header */

/* Includes ------------------------------------------------------------------*/
#include "FreeRTOS.h"
#include "task.h"
#include "main.h"
#include "cmsis_os.h"

/* Private includes ----------------------------------------------------------*/
/* USER CODE BEGIN Includes */     
#include "usart.h"
#include "spi.h"
#include <string.h>
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
/* USER CODE BEGIN Variables */

/* USER CODE END Variables */
/* Definitions for HeartBeatTask */
osThreadId_t HeartBeatTaskHandle;
const osThreadAttr_t HeartBeatTask_attributes = {
  .name = "HeartBeatTask",
  .priority = (osPriority_t) osPriorityNormal,
  .stack_size = 512 * 4
};
/* Definitions for MemoryTask */
osThreadId_t MemoryTaskHandle;
const osThreadAttr_t MemoryTask_attributes = {
  .name = "MemoryTask",
  .priority = (osPriority_t) osPriorityHigh,
  .stack_size = 2048 * 4
};
/* Definitions for ADCTask */
osThreadId_t ADCTaskHandle;
const osThreadAttr_t ADCTask_attributes = {
  .name = "ADCTask",
  .priority = (osPriority_t) osPriorityAboveNormal,
  .stack_size = 1024 * 4
};
/* Definitions for ManagementThrea */
osThreadId_t ManagementThreaHandle;
const osThreadAttr_t ManagementThrea_attributes = {
  .name = "ManagementThrea",
  .priority = (osPriority_t) osPriorityAboveNormal,
  .stack_size = 512 * 4
};
/* Definitions for MemoryConfigQueue */
osMessageQueueId_t MemoryConfigQueueHandle;
const osMessageQueueAttr_t MemoryConfigQueue_attributes = {
  .name = "MemoryConfigQueue"
};
/* Definitions for MemoryDataQueue */
osMessageQueueId_t MemoryDataQueueHandle;
const osMessageQueueAttr_t MemoryDataQueue_attributes = {
  .name = "MemoryDataQueue"
};
/* Definitions for SysTick */
osTimerId_t SysTickHandle;
const osTimerAttr_t SysTick_attributes = {
  .name = "SysTick"
};
/* Definitions for MemoryDataMutex */
osMutexId_t MemoryDataMutexHandle;
const osMutexAttr_t MemoryDataMutex_attributes = {
  .name = "MemoryDataMutex"
};
/* Definitions for MemoryConfigMutex */
osMutexId_t MemoryConfigMutexHandle;
const osMutexAttr_t MemoryConfigMutex_attributes = {
  .name = "MemoryConfigMutex"
};
/* Definitions for TelemetrySememphore */
osSemaphoreId_t TelemetrySememphoreHandle;
const osSemaphoreAttr_t TelemetrySememphore_attributes = {
  .name = "TelemetrySememphore"
};

/* Private function prototypes -----------------------------------------------*/
/* USER CODE BEGIN FunctionPrototypes */

/* USER CODE END FunctionPrototypes */

void Heartbeat(void *argument);
void MemoryEntry(void *argument);
void ADCData(void *argument);
void StartTask04(void *argument);
void SysTickRef(void *argument);

void MX_FREERTOS_Init(void); /* (MISRA C 2004 rule 8.1) */

/**
  * @brief  FreeRTOS initialization
  * @param  None
  * @retval None
  */
void MX_FREERTOS_Init(void) {
  /* USER CODE BEGIN Init */

  /* USER CODE END Init */
  /* Create the mutex(es) */
  /* creation of MemoryDataMutex */
  MemoryDataMutexHandle = osMutexNew(&MemoryDataMutex_attributes);

  /* creation of MemoryConfigMutex */
  MemoryConfigMutexHandle = osMutexNew(&MemoryConfigMutex_attributes);

  /* USER CODE BEGIN RTOS_MUTEX */
	/* add mutexes, ... */
  /* USER CODE END RTOS_MUTEX */

  /* Create the semaphores(s) */
  /* creation of TelemetrySememphore */
  TelemetrySememphoreHandle = osSemaphoreNew(1, 1, &TelemetrySememphore_attributes);

  /* USER CODE BEGIN RTOS_SEMAPHORES */
	/* add semaphores, ... */
  /* USER CODE END RTOS_SEMAPHORES */

  /* Create the timer(s) */
  /* creation of SysTick */
  SysTickHandle = osTimerNew(SysTickRef, osTimerPeriodic, NULL, &SysTick_attributes);

  /* USER CODE BEGIN RTOS_TIMERS */
	/* start timers, add new ones, ... */
  /* USER CODE END RTOS_TIMERS */

  /* Create the queue(s) */
  /* creation of MemoryConfigQueue */
  MemoryConfigQueueHandle = osMessageQueueNew (16, sizeof(uint32_t), &MemoryConfigQueue_attributes);

  /* creation of MemoryDataQueue */
  MemoryDataQueueHandle = osMessageQueueNew (255, sizeof(uint32_t), &MemoryDataQueue_attributes);

  /* USER CODE BEGIN RTOS_QUEUES */
	/* add queues, ... */
  /* USER CODE END RTOS_QUEUES */

  /* Create the thread(s) */
  /* creation of HeartBeatTask */
  HeartBeatTaskHandle = osThreadNew(Heartbeat, NULL, &HeartBeatTask_attributes);

  /* creation of MemoryTask */
  MemoryTaskHandle = osThreadNew(MemoryEntry, NULL, &MemoryTask_attributes);

  /* creation of ADCTask */
  ADCTaskHandle = osThreadNew(ADCData, NULL, &ADCTask_attributes);

  /* creation of ManagementThrea */
  ManagementThreaHandle = osThreadNew(StartTask04, NULL, &ManagementThrea_attributes);

  /* USER CODE BEGIN RTOS_THREADS */
	/* add threads, ... */
  /* USER CODE END RTOS_THREADS */

}

/* USER CODE BEGIN Header_Heartbeat */
/**
 * @brief  Function implementing the HeartBeatTask thread.
 * @param  argument: Not used
 * @retval None
 */
/* USER CODE END Header_Heartbeat */
void Heartbeat(void *argument)
{
  /* USER CODE BEGIN Heartbeat */
	uint8_t *msg = "Hello From Heartbeat Thread!\n\r";
	/* Infinite loop */
	for (;;) {
		HAL_GPIO_TogglePin(LED_1_GPIO_Port, LED_1_Pin);
		//Huart4_send(msg, strlen((char*) msg));
		osDelay(200);
	}
  /* USER CODE END Heartbeat */
}

/* USER CODE BEGIN Header_MemoryEntry */
/**
 * @brief Function implementing the MemoryTask thread.
 * @param argument: Not used
 * @retval None
 */
/* USER CODE END Header_MemoryEntry */
void MemoryEntry(void *argument)
{
  /* USER CODE BEGIN MemoryEntry */
	uint8_t *msg_u4 = "Hello From Memory Thread!\n\r";
	osEvent t;
	HAL_GPIO_WritePin(FL_2_RES_GPIO_Port, FL_2_RES_Pin, GPIO_PIN_SET);
	osDelay(20);
	HAL_GPIO_WritePin(FL_2_RES_GPIO_Port, FL_2_RES_Pin, GPIO_PIN_RESET);
	/* Infinite loop */
	for (;;) {
		HAL_GPIO_TogglePin(LED_4_GPIO_Port, LED_4_Pin);
		//  Huart4_send(msg_u4, strlen((char*)msg_u4));
		InterSPUTransmit((uint8_t*) "asdf", 4);
		/*READ ID*/
		uint8_t buf[] = { 0x90, 0x00, 0x00, 0x01 };
		/*ALTERNATIV*/
		uint8_t b[] = "\x090\x000\x000\x001";

		uint8_t buffer[100];
		for (int i = 0; i < 100; i++) {
			buffer[i] = 0;
		}
		HAL_GPIO_WritePin(FL_2_CS1_GPIO_Port, FL_2_CS1_Pin, GPIO_PIN_RESET);
		//HAL_GPIO_WritePin(FL_2_CS2_GPIO_Port, FL_2_CS2_Pin, GPIO_PIN_RESET);
//S		HAL_SPI_Transmit_IT(&hspi2, "Hallo Welt!", 11);
//		HAL_SPI_Transmit_IT(&hspi3, "Hallo Welt!", 11);
//		HAL_SPI_Transmit_IT(&hspi4, "Hallo Welt!", 11);
//		HAL_SPI_Transmit_IT(&hspi5, "Hallo Welt!", 11);
//		HAL_SPI_Transmit_IT(&hspi6, "Hallo Welt!", 11);
		HAL_SPI_Transmit_IT(&hspi2, b, 4);
//		HAL_SPI_Transmit_IT(&hspi3, b, 4);
//		HAL_SPI_Transmit_IT(&hspi4, b, 4);
//		HAL_SPI_Transmit_IT(&hspi5, b, 4);
//		HAL_SPI_Transmit_IT(&hspi6, b, 4);
		HAL_SPI_Receive_IT(&hspi2, buffer, 4);
		for (int i = 0; i < 100; i++) {
			if (buffer[i] != 0) {
				Huart4_send("FOUND!\n\r", strlen("FOUND!\n"));
				Huart4_send(buffer, 4);
				Huart4_send("END\n\r",strlen("END\n\r"));
			}
		}

		HAL_GPIO_WritePin(FL_2_CS1_GPIO_Port, FL_2_CS1_Pin, GPIO_PIN_SET);
		HAL_GPIO_WritePin(FL_2_CS2_GPIO_Port, FL_2_CS2_Pin, GPIO_PIN_SET);
		osDelay(200);
	//	t = osSignalWait(0x01 | 0x02, 50);
//		if (t.status == osEventSignal) {
//			if (t.value.signals & 0x01) {
//				uint8_t * m = "RX Interrupt!! \n\r";
//				Huart4_send(m, strlen(m));
//			} else if (t.value.signals & 0x02) {
//				uint8_t * m = "TX Complete! \n\r";
//				Huart4_send(m, strlen(m));
//			}
//		}

	}
  /* USER CODE END MemoryEntry */
}

/* USER CODE BEGIN Header_ADCData */
/**
 * @brief Function implementing the ADCTask thread.
 * @param argument: Not used
 * @retval None
 */
/* USER CODE END Header_ADCData */
void ADCData(void *argument)
{
  /* USER CODE BEGIN ADCData */
	uint8_t *msg = "Hello From ADC Thread!\n\r";
	/* Infinite loop */
	for (;;) {
		HAL_GPIO_TogglePin(LED_3_GPIO_Port, LED_3_Pin);
		//Huart4_send(msg, strlen((char*) msg));
		osDelay(500);
	}
  /* USER CODE END ADCData */
}

/* USER CODE BEGIN Header_StartTask04 */
/**
* @brief Function implementing the ManagementThrea thread.
* @param argument: Not used
* @retval None
*/
/* USER CODE END Header_StartTask04 */
void StartTask04(void *argument)
{
  /* USER CODE BEGIN StartTask04 */
  /* Infinite loop */
  for(;;)
  {
    osDelay(1);
  }
  /* USER CODE END StartTask04 */
}

/* SysTickRef function */
void SysTickRef(void *argument)
{
  /* USER CODE BEGIN SysTickRef */

  /* USER CODE END SysTickRef */
}

/* Private application code --------------------------------------------------*/
/* USER CODE BEGIN Application */

/* USER CODE END Application */

/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/
