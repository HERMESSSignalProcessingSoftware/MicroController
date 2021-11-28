/*
 * tm.c
 *
 *  Created on: 26.06.2021
 *      Author: Robin Grimsmann
 */

#include "telemetry.h"

uint8_t TransmissionPtr[60];

void InitTelemetry(void) {
    //TODO: Do other TM Stuff here
    //- Init RS232 for telemetry
    //- Add functions for transmitting 
    //  - Maybe add functions for partial transmitting

    for (int i = 0; i < FRAMESIZE; i++) {
        TransmissionPtr[i] = 0;
    }
}
