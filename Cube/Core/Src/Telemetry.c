/*
 * Telemetry.c
 *
 *  Created on: 27.05.2020
 *      Author: Robin Grimsmann
 */

#include "Telemetry.h"
#include "usart.h"

extern osSemaphoreId_t TelemetrySememphoreHandle;

/**
 * CreateHeader
 * @param status: the status of the software
 */
telemetry_header_t CreateHeader(uint32_t status) {
	telemetry_header_t header;
	header.number = PackageNumber;
	header.systemstatus = status;
	return header;
}

/**
 * CreatePackage
 * @param header: the created header struct with information about the mcu
 * @param data: the bytes to send back to earth
 */
telemetry_t CreatePackage(telemetry_header_t *header, uint8_t *data) {
	telemetry_t package;
	package.header.number = header->number;
	package.header.systemstatus = header->systemstatus;
	//Copy data
	for(int i = 0; i < NUMBEROFBYTES; i++) {
		package.data[i] = data[i];
	}
	return package;
}

/**
 * SendPackage
 * @param the package to send to earth
 */
uint32_t SendPackage(telemetry_t *package) {
	if (package) {
		Huart8_send((uint8_t *)package, SIZE);
	}
}
