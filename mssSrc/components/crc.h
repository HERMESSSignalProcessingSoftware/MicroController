/*
 * crc.h
 *
 *  Created on: 16.02.2022
 *      Author: RG
 */

#ifndef COMPONENTS_CRC_H_
#define COMPONENTS_CRC_H_

#include <stdint.h>

#define CRC32_FAST

/**
 *
 * @param buffer
 * @param len
 * @return
 */
uint32_t crc32(const uint8_t *buffer, uint32_t len);



#endif /* COMPONENTS_CRC_H_ */
