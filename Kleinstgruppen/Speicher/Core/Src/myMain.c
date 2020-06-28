/*
 * myMain.c
 *
 *  Created on: Jun 4, 2020
 *      Author: tobias
 */
#include "main.h"
#include "cmsis_os.h"
#include <stdio.h>
#include "cypress.h"

extern SPI_HandleTypeDef hspi5;

void myStillAlive(void * argument);

//SPI Daten
//uint8_t writeBuffer[256];
//uint8_t readBuffer[256];

void myMain(void * args){
	//////////////////////////////////////////////////////////////////////////////////
//	SPI_Values test;
//	test.CS_Pin = GPIO_PIN_3;
//	test.CS_Port = GPIOE;
//	test.spihandle = &hspi5;
	//////////////////////////////////////////////////////////////////////////////////

	//CS 1+2 auf HIGH
	HAL_GPIO_WritePin(GPIOE, GPIO_PIN_3, GPIO_PIN_SET);
	HAL_GPIO_WritePin(GPIOE, GPIO_PIN_6, GPIO_PIN_SET);

	osThreadNew(myStillAlive,NULL,NULL);


	printf("%ld ", testMemory());
	while(1){
		osDelay(1);
	}
//	for(int i = 0; i<256;i++)
//	{
//					writeBuffer[i] = i;
//					readBuffer[i] = 0;
//				}
//	//Buffer und Adresse zum schreiben übergeben
//	writePage(writeBuffer, 0x00000000, test);
//	//chipErase();
//	osDelay(1000);
//	  while(1){
//		  readPage(readBuffer, 0x00000000, test);
//		  for(int y = 0; y<256; y++){
//			  printf("%d ", readBuffer[y]);
//			  if(y % 50 == 0 && y != 0){
//				  printf("\n\r");
//			  }
//		  }
//		  printf(" Ende\n\r");
//		  osDelay(10000);
//	  }
}
