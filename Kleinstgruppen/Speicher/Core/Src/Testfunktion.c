/*
 * Testfunktion.c
 *
 *  Created on: 28.06.2020
 *      Author: tobias
 *      Funktionen zum Testen des Speichers
 */
#include "main.h"
#include "cmsis_os.h"
#include <stdio.h>
#include "cypress.h"


extern SPI_HandleTypeDef hspi5;


#define PAGE_COUNT 125000

uint32_t testMemory(void){
	SPI_Values DUT;
	DUT.CS_Pin = GPIO_PIN_3;
	DUT.CS_Port = GPIOE;
	DUT.spihandle = &hspi5;

	uint8_t writeBuffer[256];
	uint8_t readBuffer[256] = {0};
	uint32_t adresse = 0;

	//Testdaten initialisieren
	for(int i = 0; i<256;i++){
		writeBuffer[i] = i;
		}

	//CHIP löschen
	chipErase(DUT);
	//evtl Zusätzliche Schleife für die verschiedenen Chips und CS pins
	for(int i = 0; i < PAGE_COUNT; i++){
		adresse = i * 0x1000;
		//Daten für eine Page schicken
		writePage(writeBuffer, adresse, DUT);
		//Warten bis fertig geschrieben wurde
		writeReady(DUT);
		//Selbe page auslesen
		readPage(readBuffer, adresse, DUT);
		//Inhalt vergleichen
		for(int y = 0;y < 256;y++){
			//Wenn inhalt nicht gleich
			if(writeBuffer[y] != readBuffer[y])
				return 1;
		}
		//readBuffer auf null initialisieren
		for(int z = 0; z<256;z++){
			readBuffer[z] = 0;
			}
	}
	return 0;
}
