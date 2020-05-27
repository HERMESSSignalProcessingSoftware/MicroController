#ifndef _INCLUDED_SENSOR_TCA9546A_H_
#define _INCLUDED_SENSOR_TCA9546A_H_

#include <cyu3types.h>

#define TCA9546A_I2C_ADDRESS_READ   0xE1
#define TCA9546A_I2C_ADDRESS_WRITE  0xE0


CyU3PReturnStatus_t
TCA9546A_enableChannels
(
        uint8_t *data
);


CyU3PReturnStatus_t
TCA9546A_readChannels
(
    uint8_t *data
);

#endif
