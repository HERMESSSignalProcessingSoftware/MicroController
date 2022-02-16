/*
 * telemetry.h
 *
 *  Created on: 27.01.2022
 *      Author: RG
 */

#ifndef COMPONENTS_TELEMETRY_H_
#define COMPONENTS_TELEMETRY_H_

#include <stdint.h>
#include "../drivers/apb_telemetry/telemetry_driver.h"
#include "../sb_hw_platform.h"
#include "cortex_nvic.h"
#include "../CMSIS/m2sxxx.h"

#define NUMBER_OF_REGS      18
#define NUMBER_OF_ENTRIES   15

#define STATUS_INTERRUPT_TX     (1 << 31)
#define STATUS_INTERRUPT_RX     (1 << 30)

typedef struct {
    /**/
    uint32_t timestamp;
    uint32_t stamp11;
    uint32_t stamp12;
    uint32_t stamp21;
    /**/
    uint32_t stamp22;
    uint32_t stamp31;
    uint32_t stamp32;
    uint32_t stamp41;
    /**/
    uint32_t stamp42;
    uint32_t stamp51;
    uint32_t stamp52;
    uint32_t stamp61;
    /**/
    uint32_t stamp62;
    uint32_t statusReg1;
    uint32_t statusReg2;
}Telemetry_t;


typedef struct {
    uint32_t startMeta;
    uint32_t data1;
    uint32_t data2;
    uint32_t data3;
    uint32_t data4;
    uint32_t endMeta;
} Frame_t;

typedef struct {
    Frame_t frame1;
    Frame_t frame2;
    Frame_t frame3;
    Frame_t frame4; /* 4 * 6 * 4 = */
} Telemetry_Sending_t;

/**
 *
 * @param data
 */
void LoadTXData(Telemetry_t data);

/**
 *
 */
void __inline__ static InitTelemetry(void) {
    InitTMDriver(BAUD_38400, GAP_3MS, CONFIG_INTERRPUT_ENA | CONFIG_GLOBAL_START);
    NVIC_EnableIRQ(FabricIrq7_IRQn);
    NVIC_ClearPendingIRQ(FabricIrq7_IRQn);
}

void __inline__ static StartTelemetry(void) {
    TelemetryTransmissionStart();
}


void __inline__ static StopTelemetry(void) {
    TelemetryTransmissionStop();
}

uint32_t TelemetryGetConfigRegister(void);

/**
 *
 * @return
 */
uint32_t TelemetryGetStatusRegister(void);

/**
 *
 * @param value
 */
void __inline__ TelemetrySetStatusRegister(uint32_t value) {
    TelemetryStatusRegister_set(value);
}

/**
 *
 */
void TelemetryClearInterrupts(void);

/**
 *
 * @return
 */
Frame_t RXData(void);

void TelemetryGlobalStartEnable(void);

#endif /* COMPONENTS_TELEMETRY_H_ */
