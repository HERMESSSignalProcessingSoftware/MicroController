/*
 * telemetry_driver.h
 *
 *  Created on: 27.01.2022
 *      Author: RG
 */

#ifndef DRIVERS_APB_TELEMETRY_TELEMETRY_DRIVER_H_
#define DRIVERS_APB_TELEMETRY_TELEMETRY_DRIVER_H_


#include <stdint.h>
#include "../../sb_hw_platform.h"

typedef struct {
    uint32_t data1;
    uint32_t data2;
    uint32_t data3;
    uint32_t data4;
    uint32_t data5;
    uint32_t data6;
} TelemetryRXFrame_t;

#define MemoryAddressModifier   (1 << 8)
#define MemoryRXAddresModifier  (1 << 9)
#define MemoryAddressShift(i)   (i << 2)
#define StartMemoryAddress      0x00
#define EndMemoryAddress        23
/*  */
#define RegisterTransmitCounter 0x000
#define RegisterConfig          0x004
#define RegisterStatus          0x008
#define RegisterConfigBaud      0x00C
#define RegisterConfigGap       0x010
#define RegisterRX              0x014
/* Just Reading access! */
#define READRegisterZero        0x064

#define LOWESTTransmitRegister          RegisterTransmit1
#define HIGHESTTransmitRegister         RegisterTransmit18

#define TELEMETRY_ADDR(i) (ADDR_TELEMETRY | i)

/**
 * Offset to 0
 * 0 + 4 = 4 (Start of the tx register block)
 */
#define OFFSET(i) (i + RegisterTransmit1)

#define BAUD_9600   5208
#define BAUD_19200  2604
#define BAUD_38400  1302

#define GAP_3MS     150000
#define GAP_30kBits 87500

#define CONFIG_RESET_TX_BUFFER  (1 << 31)
#define CONFIG_RESET_RX_BUFFER  (1 << 30)
#define CONFIG_START            (1 << 1)
#define CONFIG_GLOBAL_START     (1 << 2)
#define CONFIG_INTERRPUT_ENA    (1 << 0)


/*TODO: implement TX counter (vhdl too) and RA (RX polling mode) */



/**
 *
 * @param baud
 * @param gap
 */
void InitTMDriver(uint32_t baud, uint32_t gap, uint32_t config);

void TelemetyLoadTXMemory(uint32_t data, uint32_t row);

/**
 *
 * @return
 */
uint32_t TelemetryGetRXMemoryLine(uint32_t row);

/**
 *
 */
void TelemetryTransmissionStart(void);

/**
 *
 */
void TelemetryTransmissionStop(void);

/**
 *
 * @return
 */
uint32_t TelemetryStatusRegister_get(void);

/**
 *
 * @param value
 */
void TelemetryStatusRegister_set(uint32_t value);

/**
 *
 * @return
 */
uint32_t TelemetryGetConfigReg(void);

/**
 *
 * @param value
 */
void TelemetryWriteConfigReg(uint32_t value);

void EnableSoftwareAutoStart(void);
#endif /* DRIVERS_APB_TELEMETRY_TELEMETRY_DRIVER_H_ */
