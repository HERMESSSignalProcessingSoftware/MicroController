/*
 * HERMESS.h
 *
 *  Created on: 28.12.2021
 *      Author: RG
 */

#ifndef COMPONENTS_HERMESS_H_
#define COMPONENTS_HERMESS_H_

#include <stdint.h>

typedef struct {
    uint32_t metaAddress;
    uint32_t metaAddressOffset;
} SysConfig_t;

extern volatile SysConfig_t system;

#define START_OF_DATA_SEGMENT 0x200
#define START_OF_META_SEGMENT 0x00

#endif /* COMPONENTS_HERMESS_H_ */
