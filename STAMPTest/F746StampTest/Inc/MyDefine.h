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
//#define PAGESIZE 256
#define WATERMARK_MAX 2 * PAGESIZE

#define CHANNEL_6 (1 << 13)
#define CHANNEL_7 (1 << 14)

/*MACROS*/
/**
 * Returns the index in [0:10] from an given GPIO Pin block
 */
#define LOOKUP_PINBLOCK_INDEX(i) ((uint32_t)i & 0x0000FFFF) >> 10

/**
 * Look Up Pin index by counting leading zeros using ARM clz instruction
 */
#define LOOKUP_PIN_INDEX(i) (31 - __builtin_clz(i))

#define NUMBER_OF_PINBLOCKS 11
#define NUMBER_OF_PINS 16

/*Lookup table*/
extern uint8_t ADCLookup[NUMBER_OF_PINBLOCKS][NUMBER_OF_PINS];
/* ADC bit map */
extern uint32_t ADCBitMap;

#define ThreadFlagHBStart 	0x1
#define ThreadFlagHBStop 	0x2

extern uint8_t receivingdata[4];
extern uint8_t readdata[3]; // READ DATA Befehlssatz
extern uint8_t readregister[2]; // READ Register Befehlssatz
extern uint8_t nop[2]; // NOP Befehle
extern uint8_t transmitdata[3]; // READ DATA Befehlssatz und 16 SCLK's
extern uint16_t result[300]; //FANGVARIABLE
extern uint8_t registervalue[6]; //ERGEBNIS des Registers
extern uint8_t reset_command[1];
extern uint8_t sdatac_command[1];
extern uint8_t wreg_command[6]; //BCS -> RESET dann CHANNEL ANX0 auswahl
extern uint8_t sync_command[1];

#endif
