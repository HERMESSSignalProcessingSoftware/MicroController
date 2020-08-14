/*
 * Telemetry.c
 *
 *  Created on: 27.05.2020
 *      Author: Robin Grimsmann
 */

#include "Telemetry.h"
#include "usart.h"
#include "crc.h"
#include "test.h"

extern CRC_HandleTypeDef hcrc;

/**
 * CreateHeader
 * @brief create header
 * @param status: the status of the software
 * @return telemetry_header_t: Header to be used for next package!
 */
telemetry_header_t CreateHeader(uint32_t status) {
	telemetry_header_t header;
	header.number = PackageNumber;
	header.systemstatus = status;
	return header;
}

/**
 * CreatePackage
 * @brief Creates a package, copies values form header and calculates crc
 *
 * @param header: the created header struct with information about the mcu
 * @param data: the bytes to send back to earth
 * @return telemetry_t the created package
 */
telemetry_t CreatePackage(telemetry_header_t *header, uint8_t *data) {
	telemetry_t package;
	package.header.number = header->number;
	package.header.systemstatus = header->systemstatus;
	//Copy data
	for (int i = 0; i < NUMBEROFBYTES; i++) {
		package.data[i] = data[i];
	}
	int t = (SIZE - 4) / 4;
	uint32_t crc_c = HAL_CRC_Calculate(&hcrc, (uint32_t*) &package, t); //-2 last to bytes are not set and used for crc
	package.crc = crc_c;
	return package;
}

/**
 * @brief Sends a package via RS422 to earth
 *
 * @param the package to send to earth
 * @return uint32_t status. OK = 0
 */
uint32_t SendPackage(telemetry_t *package) {
	if (package) {
		Huart8_send((uint8_t *) package, SIZE);
		PackageNumber++;
	}
	return 0;
}

/**
 * Tests for this file
 */
uint32_t testTelemetry(void) {
	uint32_t b = 1;
	telemetry_header_t header = CreateHeader(0xf0f0f0f0);
	b &= (header.number == 0);
	b &= (header.systemstatus == 0xf0f0f0f0);
	telemetry_header_t header1 = CreateHeader(0);
	b &= (header1.number == 0);
	b &= (header1.systemstatus == 0);
	telemetry_header_t header2 = CreateHeader(0xffffffff); // no status known
	b &= (header2.number == 0);
	b &= (header2.systemstatus == 0xffffffff);
	telemetry_t msg = CreatePackage(&header, (uint8_t*) "123412341234123412");
	b &= (msg.crc == 0xcab5fb45);
	b &= (msg.data[0] == '1');
	b &= (msg.data[NUMBEROFBYTES - 1] == '2');
	telemetry_t msg2 = CreatePackage(&header, (uint8_t*) "432143214321432143");
	b &= (msg2.crc != 0xcab5fb45);
	b &= (msg2.data[1] == '3');
	b &= (msg2.data[NUMBEROFBYTES - 2] == '4');
	SendPackage(&msg);
	telemetry_header_t header3 = CreateHeader(0x0);
	uint8_t data[] = {0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0};
	//telemetry_t msg3 = CreatePackage(&header3, data);
	b &= (header3.number == 1);
	return b;
}

