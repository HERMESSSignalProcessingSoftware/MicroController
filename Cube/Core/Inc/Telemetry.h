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

/**
 * there are 9 times 16 bit ADCs
 * 4 bytes are used to transmit the current mcu status and the adc status to earth
 * there also will be a number to identify the frame also 4 bytes
 */
#define NUMBEROFBYTES 18
/* Header size*/
#define HEADERSIZE 8
/* Using 32 bit crc */
#define CRC_LENGHT 4
#define SIZE HEADERSIZE + NUMBEROFBYTES + CRC_LENGHT
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
	uint32_t crc;
} telemetry_t;

/**
 * CreateHeader
 * @brief create header
 * @param status: the status of the software
 * @return telemetry_header_t: Header to be used for next package!
 */
telemetry_header_t CreateHeader(uint32_t status);

/**
 * CreatePackage
 * @brief Creates a package, copies values form header and calculates crc
 *
 * @param header: the created header struct with information about the mcu
 * @param data: the bytes to send back to earth
 * @return telemetry_t the created package
 */
telemetry_t CreatePackage(telemetry_header_t *header, uint8_t *data);

/**
 * @brief Sends a package via RS422 to earth
 *
 * @param the package to send to earth
 * @return uint32_t status. OK = 0
 */
uint32_t SendPackage(telemetry_t *package);

/**
 * Counter of send packages
 * Will be increased after package was send!
 */
uint32_t PackageNumber;

/**
 * Init Telemetry
 */
void InitTelemetry(void);
#endif /* INC_TELEMETRY_H_ */
