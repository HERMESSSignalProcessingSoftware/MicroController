/*
 * Telemetry.h
 *
 *  Created on: 27.05.2020
 *      Author: Robin Grimsmann
 */

#ifndef INC_TELEMETRY_H_
#define INC_TELEMETRY_H_

#include <stdlib.h>
#include "main.h"
#include "cmsis_os.h"

/**
 * there are 12 times 16 bit ADCs -> 192 bit = 24 byte
 * 8 bytes are used to transmit the current mcu status and the adc status to earth
 * there also will be a number to identify the frame
 */
#define NUMBEROFBYTES 24
#define SIZE 32
/**
 * Timestamp and number as identification to the ground station
 * system status contains [11:0] ADC error bits. [14:12] MCU Status bits.
 * */
typedef struct {
	uint32_t number;
	uint32_t systemstatus;
} telemetry_header_t;

/**
 *
 */
typedef struct {
	telemetry_header_t header;
	uint8_t data[NUMBEROFBYTES];
} telemetry_t;

/**
 * CreateHeader
 * @param status: the status of the software
 */
telemetry_header_t CreateHeader(uint32_t status);

/**
 * CreatePackage
 * @param header: the created header struct with information about the mcu
 * @param data: the bytes to send back to earth
 */
telemetry_t CreatePackage(telemetry_header_t *header, uint8_t *data);

/**
 * SendPackage
 * @param the package to send to earth
 */
uint32_t SendPackage(telemetry_t *package);

/**
 * Counter of send packages
 */
uint32_t PackageNumber;

#endif /* INC_TELEMETRY_H_ */
