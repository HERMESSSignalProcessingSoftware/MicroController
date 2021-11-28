/**
 * @mainpage HERMESS TM component
 *
 * @section intro_sec Introduction
 * !!!
 *
 * @section use_sec Usage
 * !!!
 *
 * @section hw_sec Hardware requirements
 * !!!
 */

#ifndef TELEMETRY_H
#define TELEMETRY_H


#ifdef __cplusplus
extern "C" {
#endif

#include <stdint.h>

#define FRAMESIZE 60

extern uint8_t TransmissionPtr[60];

void InitTelemetry(void);



#ifdef __cplusplus
}
#endif


#endif
