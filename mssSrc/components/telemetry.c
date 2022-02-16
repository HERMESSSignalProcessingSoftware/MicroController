/*
 * telemetry.c
 *
 *  Created on: 27.01.2022
 *      Author: RG
 */

#include "telemetry.h"
#include "../drivers/apb_telemetry/telemetry_driver.h"
#include <stdint.h>

Frame_t CreateFrame(uint32_t* ptr, uint32_t length)  {
    Frame_t frame = { 0 };
    uint32_t *framePtr = &(frame.data1);
    if (ptr) {
        for (uint32_t i = 0; i < length; i++) {
            framePtr[i] = ptr[i];
        }
    }
    return frame;
}

Telemetry_Sending_t ConvertToSending(Telemetry_t* dataPtr) {
    Telemetry_Sending_t packet = { 0 };
    if (dataPtr) {
        packet.frame1 = CreateFrame((uint32_t*) &(dataPtr->timestamp), 4);
        packet.frame2 = CreateFrame((uint32_t*) &(dataPtr->stamp22), 4);
        packet.frame3 = CreateFrame((uint32_t*) &(dataPtr->stamp42), 4);
        packet.frame4 = CreateFrame((uint32_t*) &(dataPtr->stamp62), 3);
    }
    return packet;
}

uint32_t TelemetryGetStatusRegister(void) {
    return TelemetryStatusRegister_get();
}


/**
 *
 * @param data
 */
void LoadTXData(Telemetry_t data) {
    Telemetry_Sending_t packet = ConvertToSending(&data);
    uint32_t *dataPtr = (uint32_t*) &packet;
    uint32_t counter = 0;
    for (uint32_t i = StartMemoryAddress; i <= EndMemoryAddress; i++) {
        TelemetyLoadTXMemory(dataPtr[i], i);
    }
}


void TelemetryClearInterrupts(void) {
    uint32_t statusReg = TelemetryStatusRegister_get();
    statusReg &= ~(STATUS_INTERRUPT_RX);
    statusReg &= ~(STATUS_INTERRUPT_TX);
    TelemetryStatusRegister_set(statusReg);
}

uint32_t TelemetryGetConfigRegister(void) {
    return TelemetryGetConfigReg();
}

void TelemetryGlobalStartEnable(void) {
    EnableSoftwareAutoStart();
}

Frame_t RXData(void) {
    Frame_t rxData = { 0 };
    uint32_t *ptr = (uint32_t*)&rxData;
    uint32_t configReg = TelemetryGetConfigReg();
    for (uint32_t i = 0; i < 6; i++) {
        ptr[i] = TelemetryGetRXMemoryLine(i);
    }
    TelemetryWriteConfigReg(configReg | CONFIG_RESET_RX_BUFFER);
    return rxData;
}
