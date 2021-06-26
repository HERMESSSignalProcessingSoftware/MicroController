/*
 * tm.c
 *
 *  Created on: 26.06.2021
 *      Author: Robin Grimsmann
 */

#include "tm.h"

uint8_t TransmissionPtr[60];

void InitTelemetry(void) {
    //TODO: Do other TM Stuff here

    for (int i = 0; i < FRAMESIZE; i++) {
        TransmissionPtr[i] = 0;
    }
}
