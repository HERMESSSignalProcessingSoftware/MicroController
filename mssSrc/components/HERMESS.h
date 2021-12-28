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



#endif /* COMPONENTS_HERMESS_H_ */
