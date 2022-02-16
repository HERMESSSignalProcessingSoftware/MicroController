/*
 * telemetry_driver.c
 *
 *  Created on: 27.01.2022
 *      Author: RG
 */

#include "telemetry_driver.h"
#include "../../hal/hal.h"

/**
 *
 * @param baud
 * @param gap
 */
void InitTMDriver(uint32_t baud, uint32_t gap, uint32_t config) {
    HW_set_32bit_reg(TELEMETRY_ADDR(RegisterConfigBaud), baud);
    HW_set_32bit_reg(TELEMETRY_ADDR(RegisterConfigGap), gap);
    HW_set_32bit_reg(TELEMETRY_ADDR(RegisterConfig), config);
}


void TelemetyLoadTXMemory(uint32_t data, uint32_t row) {
    uint32_t address = TELEMETRY_ADDR(MemoryAddressShift(row)) | MemoryAddressModifier;

    HW_set_32bit_reg(address , data);
}

/**
 *
 * @return
 */
uint32_t TelemetryGetRXMemoryLine(uint32_t row){
    return HW_get_32bit_reg(TELEMETRY_ADDR(MemoryAddressShift(row)) | MemoryRXAddresModifier);
}

/**
 *
 */
void TelemetryTransmissionStart(void) {
    uint32_t configRegister = HW_get_32bit_reg(TELEMETRY_ADDR(RegisterConfig));
    HW_set_32bit_reg(TELEMETRY_ADDR(RegisterConfig), configRegister | CONFIG_START);
}

void TelemetryTransmissionStop(void) {
    uint32_t configRegister = HW_get_32bit_reg(TELEMETRY_ADDR(RegisterConfig));
    configRegister &= ~(CONFIG_START);
    configRegister &= ~(CONFIG_GLOBAL_START);
    HW_set_32bit_reg(TELEMETRY_ADDR(RegisterConfig), configRegister);
}

uint32_t TelemetryGetConfigReg(void) {
    return HW_get_32bit_reg(TELEMETRY_ADDR(RegisterConfig));
}

void TelemetryWriteConfigReg(uint32_t value) {
    HW_set_32bit_reg(TELEMETRY_ADDR(RegisterConfig), value);
}

uint32_t TelemetryStatusRegister_get(void) {
    return HW_get_32bit_reg(TELEMETRY_ADDR(RegisterStatus));
}

void __inline__ TelemetryStatusRegister_set(uint32_t value) {
    HW_set_32bit_reg(TELEMETRY_ADDR(RegisterStatus), value);
}

void EnableSoftwareAutoStart(void) {
    uint32_t config_reg = HW_get_32bit_reg(TELEMETRY_ADDR(RegisterConfig));
    HW_set_32bit_reg(TELEMETRY_ADDR(RegisterConfig), config_reg | CONFIG_GLOBAL_START);
}
