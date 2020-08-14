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
#include "signal.h"
#include "usart.h"
#include "MyDefine.h"
#include <string.h>
#include <stdio.h>
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
/* Definitions for measureTask */
osThreadId_t measureTaskHandle;
const osThreadAttr_t measureTask_attributes = {
  .name = "measureTask",
  .priority = (osPriority_t) osPriorityNormal,
  .stack_size = 128 * 4
};
/* Definitions for UARTTransmit */
osThreadId_t UARTTransmitHandle;
const osThreadAttr_t UARTTransmit_attributes = {
  .name = "UARTTransmit",
  .priority = (osPriority_t) osPriorityNormal,
  .stack_size = 128 * 4
};
/* Definitions for HeartBeat */
osThreadId_t HeartBeatHandle;
const osThreadAttr_t HeartBeat_attributes = {
  .name = "HeartBeat",
  .priority = (osPriority_t) osPriorityLow,
  .stack_size = 128 * 4
};
/* Definitions for dataQueue */
osMessageQueueId_t dataQueueHandle;
const osMessageQueueAttr_t dataQueue_attributes = {
  .name = "dataQueue"
};

/* Private function prototypes -----------------------------------------------*/
/* USER CODE BEGIN FunctionPrototypes */
extern uint16_t globaldata[];
extern uint32_t watermark;
/* USER CODE END FunctionPrototypes */

void StartMeasurement(void *argument);
void TransmitTask(void *argument);
void HeartBeatTask(void *argument);

void MX_FREERTOS_Init(void); /* (MISRA C 2004 rule 8.1) */

/**
  * @brief  FreeRTOS initialization
  * @param  None
  * @retval None
  */
void MX_FREERTOS_Init(void) {
  /* USER CODE BEGIN Init */

  /* USER CODE END Init */

  /* USER CODE BEGIN RTOS_MUTEX */
	/* add mutexes, ... */
  /* USER CODE END RTOS_MUTEX */

  /* USER CODE BEGIN RTOS_SEMAPHORES */
	/* add semaphores, ... */
  /* USER CODE END RTOS_SEMAPHORES */

  /* USER CODE BEGIN RTOS_TIMERS */
	/* start timers, add new ones, ... */
  /* USER CODE END RTOS_TIMERS */

  /* Create the queue(s) */
  /* creation of dataQueue */
  dataQueueHandle = osMessageQueueNew (128, sizeof(uint32_t), &dataQueue_attributes);

  /* USER CODE BEGIN RTOS_QUEUES */
	/* add queues, ... */
  /* USER CODE END RTOS_QUEUES */

  /* Create the thread(s) */
  /* creation of measureTask */
  measureTaskHandle = osThreadNew(StartMeasurement, NULL, &measureTask_attributes);

  /* creation of UARTTransmit */
  UARTTransmitHandle = osThreadNew(TransmitTask, NULL, &UARTTransmit_attributes);

  /* creation of HeartBeat */
  HeartBeatHandle = osThreadNew(HeartBeatTask, NULL, &HeartBeat_attributes);

  /* USER CODE BEGIN RTOS_THREADS */
	/* add threads, ... */
  /* USER CODE END RTOS_THREADS */

}

/* USER CODE BEGIN Header_StartMeasurement */
/**
 * @brief  Function implementing the measureTask thread.
 * @param  argument: Not used
 * @retval None
 */
/* USER CODE END Header_StartMeasurement */
void StartMeasurement(void *argument)
{
  /* USER CODE BEGIN StartMeasurement */
	/* Infinite loop */
	uint8_t cmd;
	osStatus_t status = {0};
	//HAL_UART_Transmit(&huart2, &d, 1,0);
	HAL_UART_Receive_IT(&huart2, &cmd, 1);

	for (;;) {

		osDelay(1);
	}
  /* USER CODE END StartMeasurement */
}

/* USER CODE BEGIN Header_TransmitTask */
/**
 * @brief Function implementing the UARTTransmit thread.
 * @param argument: Not used
 * @retval None
 */
/* USER CODE END Header_TransmitTask */
void TransmitTask(void *argument)
{
  /* USER CODE BEGIN TransmitTask */
	/* Infinite loop */
	osStatus_t status = {0};
	for (;;) {

		osDelay(1);
	}
  /* USER CODE END TransmitTask */
}

/* USER CODE BEGIN Header_HeartBeatTask */
/**
 * @brief Function implementing the HeartBeat thread.
 * @param argument: Not used
 * @retval None
 */
/* USER CODE END Header_HeartBeatTask */
void HeartBeatTask(void *argument)
{
  /* USER CODE BEGIN HeartBeatTask */
	uint32_t running = 0;
	/* Infinite loop */
	for (;;) {
		if (running == 0) {
			osThreadFlagsWait(ThreadFlagHBStart, osFlagsWaitAny, osWaitForever);
			running = 1;
		} else {
			osStatus_t status = osThreadFlagsWait(ThreadFlagHBStop, osFlagsWaitAny, 100);
			if (status == osErrorTimeout ) {
				HAL_GPIO_TogglePin(LD2_GPIO_Port, LD2_Pin);
			} else {
				running = 0;
			}
		}
	}
  /* USER CODE END HeartBeatTask */
}

/* Private application code --------------------------------------------------*/
/* USER CODE BEGIN Application */

/* USER CODE END Application */

/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/