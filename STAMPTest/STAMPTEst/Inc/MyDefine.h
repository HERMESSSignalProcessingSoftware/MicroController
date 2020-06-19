/*
 * task.h
 *
 *  Created on: 17.06.2020
 *      Author: Robin Grimsmann
 */

#ifndef MY_DEFINE_H__
#define MY_DEFINE_H__

//extern osThreadId_t measureTaskHandle;
//
///* Definitions for UARTTransmit */
//extern osThreadId_t UARTTransmitHandle;
//
///* Definitions for HeartBeat */
//extern osThreadId_t HeartBeatHandle;
//
///* Definitions for dataQueue */
//extern osMessageQueueId_t dataQueueHandle;

#include "main.h"

/*Buffer is 2 byte entry array */
#define PAGESIZE 1024
#define WATERMARK_MAX 2 * PAGESIZE


#endif /* TASK_H_ */
