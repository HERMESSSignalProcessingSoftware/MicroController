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
  .stack_size = 128 * 4
};
/* Definitions for DataHandleingTa */
osThreadId_t DataHandleingTaHandle;
const osThreadAttr_t DataHandleingTa_attributes = {
  .name = "DataHandleingTa",
  .priority = (osPriority_t) osPriorityHigh,
  .stack_size = 1024 * 4
};
/* Definitions for ManagementTask */
osThreadId_t ManagementTaskHandle;
const osThreadAttr_t ManagementTask_attributes = {
  .name = "ManagementTask",
  .priority = (osPriority_t) osPriorityLow,
  .stack_size = 256 * 4
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
void DataHandleing(void *argument);
void Management(void *argument);
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

  /* creation of DataHandleingTa */
  DataHandleingTaHandle = osThreadNew(DataHandleing, NULL, &DataHandleingTa_attributes);

  /* creation of ManagementTask */
  ManagementTaskHandle = osThreadNew(Management, NULL, &ManagementTask_attributes);

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

/* USER CODE BEGIN Header_DataHandleing */
/**
* @brief Function implementing the DataHandleingTa thread.
* @param argument: Not used
* @retval None
*/
/* USER CODE END Header_DataHandleing */
void DataHandleing(void *argument)
{
  /* USER CODE BEGIN DataHandleing */
  /* Infinite loop */
  for(;;)
  {
    osDelay(1);
  }
  /* USER CODE END DataHandleing */
}

/* USER CODE BEGIN Header_Management */
/**
* @brief Function implementing the ManagementTask thread.
* @param argument: Not used
* @retval None
*/
/* USER CODE END Header_Management */
void Management(void *argument)
{
  /* USER CODE BEGIN Management */
  /* Infinite loop */
  for(;;)
  {
    osDelay(1);
  }
  /* USER CODE END Management */
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
