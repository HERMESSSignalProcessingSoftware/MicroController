/*
 * Test.c
 *
 *  Created on: 16.01.2021
 *      Author: Robin Grimsmann
 */

#include "main.h"
#include "Test.h"
#include "cypress.h"


#define PAGE_COUNT 125000

/**
 * @brief: tests the memory
 * TEST: Write to memory, wait, read form memory.
 * @return 0: Passed.
 */
uint32_t MemoryTest(void) {
	SPI_Values DUT;
	DUT.CS_Pin = FL2_CS1_Pin;
	DUT.CS_Port = FL2_CS1_GPIO_Port;
	DUT.spihandle = &hspi2;

	/*TODO: all other memory dies */

	uint8_t writeBuffer[256];
	uint8_t readBuffer[256] = { 0 };
	uint32_t adresse = 0;

	//Testdaten initialisieren
	for (int i = 0; i < 256; i++) {
		writeBuffer[i] = i;
	}

	//CHIP löschen
	chipErase(DUT);
	//evtl Zusätzliche Schleife für die verschiedenen Chips und CS pins
	for (int i = 0; i < PAGE_COUNT; i++) {
		adresse = i * 0x1000;
		//Daten für eine Page schicken
		writePage(writeBuffer, adresse, DUT);
		//Warten bis fertig geschrieben wurde
		writeReady(DUT);
		//Selbe page auslesen
		readPage(readBuffer, adresse, DUT);
		//Inhalt vergleichen
		for (int y = 0; y < 256; y++) {
			//Wenn inhalt nicht gleich
			if (writeBuffer[y] != readBuffer[y])
				return 1;
		}
		//readBuffer auf null initialisieren
		for (int z = 0; z < 256; z++) {
			readBuffer[z] = 0;
		}
	}
	return 0;
}
