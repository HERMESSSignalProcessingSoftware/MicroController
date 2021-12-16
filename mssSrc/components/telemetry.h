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

#define TELMETRY_PTR(i) (uint8_t*)(i)

typedef struct {
    uint32_t timestamp;
    uint32_t statusReg1;
    uint32_t statusReg2;
    uint32_t stamp11;
    uint32_t stamp12;
    uint32_t stamp21;
    uint32_t stamp22;
    uint32_t stamp31;
    uint32_t stamp32;
    uint32_t stamp41;
    uint32_t stamp42;
    uint32_t stamp51;
    uint32_t stamp52;
    uint32_t stamp61;
    uint32_t stamp62;
}Telemmetry_t;

extern Telemmetry_t telemetryFrame;


void InitTelemetry(void);

/**
 * Transmit data to earth
 * @param one byte of data
 * @return
 */
uint32_t TransmitByte(uint8_t byte);


#ifdef __cplusplus
}
#endif


#endif
