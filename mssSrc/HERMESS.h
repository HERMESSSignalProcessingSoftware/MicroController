/*
 * HERMESS.h
 *
 *  Created on: 28.12.2021
 *      Author: RG
 */

#ifndef HAL_HERMESS_H_
#define HAL_HERMESS_H_

typedef struct {
    uint32_t metaAddress;
    uint32_t metaAddressOffset;
} SysConfig_t;

extern volatile SysConfig_t system;



#endif /* HAL_HERMESS_H_ */
