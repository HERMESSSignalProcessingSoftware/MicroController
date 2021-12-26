#include "stamps.h"

#ifdef __cplusplus
extern "C" {
#endif



#include "../hw_platform.h"
#include "../drivers/mss_gpio/mss_gpio.h"
#include "../drivers/apb_stamp/apb_stamp.h"
#include "tools.h"
#include "../drivers/mss_watchdog/mss_watchdog.h"

#define ADS_CMD_WAKEUP              0xFF00U
#define ADS_CMD_SLEEP               0xFF02U
#define ADS_CMD_SYNC                0x0404U
#define ADS_CMD_RESET               0xFF06U
#define ADS_CMD_NOP                 0xFFFFU
#define ADS_CMD_RDATA               0xFF12U
#define ADS_CMD_RDATAC              0xFF14U
#define ADS_CMD_SDATAC              0xFF16U
#define ADS_CMD_RREG(reg, num)      0x2000U | (reg << 8) | (num - 1)
#define ADS_CMD_WREG(reg, num)      0x4000U | (reg << 8) | (num - 1)
#define ADS_CMD_SYSOCAL             0xFF60U
#define ADS_CMD_SYSGCAL             0xFF61U
#define ADS_CMD_SELFOCAL            0xFF62U

#define ADS_REG_MUX0                0x00U
#define ADS_REG_VBIAS               0x01U
#define ADS_REG_MUX1                0x02U
#define ADS_REG_SYS0                0x03U
#define ADS_REG_OFC0                0x04U
#define ADS_REG_FSC0                0x07U
#define ADS_REG_IDAC0               0x0AU
#define ADS_REG_GPIOCFG             0x0CU
#define ADS_REG_GPIODIR             0x0DU
#define ADS_REG_GPIODAT             0x0EU



// stores the the addresses
static const addr_t stampsAddresses[] = {
        ADDR_STAMP_0, ADDR_STAMP_1, ADDR_STAMP_2,
        ADDR_STAMP_3, ADDR_STAMP_4, ADDR_STAMP_5
};
static const uint8_t stampsIrqnBit[] = {
        F2M_INT_STAMP_0, F2M_INT_STAMP_1, F2M_INT_STAMP_2,
        F2M_INT_STAMP_3, F2M_INT_STAMP_4, F2M_INT_STAMP_5
};
// stores instances to all stamps
static apb_stamp_t stamps[6];
// stores the callback for the data available handler
static void (*stampsIrqnDataAvail)(uint8_t, uint32_t, uint32_t) = 0;



void stampsInit (uint8_t pgaSgr, uint8_t spsSgr,
        uint8_t pgaRtd, uint8_t spsRtd) {
    // initialize ADC start GPIO and settle ADC
    MSS_GPIO_config(OUT_ADC_START, MSS_GPIO_OUTPUT_MODE);
    MSS_GPIO_set_output(OUT_ADC_START, 1);
    delay(20);

    // assemble the configuration
    const uint16_t sgrConf = 0xB000U | (pgaSgr << 4) | spsSgr;
    const uint16_t rtdConf =  0x2032U | (pgaRtd << 4) | spsRtd;
    uint32_t configflags = 0x0;

    // initialize the APB STAMP component
    for (int i = 0; i < 6; i++) {
        stamps[i] = APB_STAMP_init(stampsAddresses[i], stampsIrqnBit[i]);

        // reset all ADCs and let it settle
        APB_STAMP_writeAdc(&stamps[i],
                STAMP_REG_WRITE_DMS1 | STAMP_REG_WRITE_DMS2 | STAMP_REG_WRITE_TEMP,
                ADS_CMD_RESET,
                STAMP_MOD_NONE);
        delay(1);

        // stop continuous data conversion by ADC
        APB_STAMP_writeAdc(&stamps[i],
                STAMP_REG_WRITE_DMS1 | STAMP_REG_WRITE_DMS2 | STAMP_REG_WRITE_TEMP,
                ADS_CMD_SDATAC,
                STAMP_MOD_NONE);

        // write to registers (MUX1 and SOS0) and check if correct
        uint16_t readConf = 0;
        uint8_t confTrials = 0;
        APB_STAMP_writeAdc(&stamps[i],
                STAMP_REG_WRITE_DMS1 | STAMP_REG_WRITE_DMS2,
                ADS_CMD_WREG(ADS_REG_MUX1, 2),
                STAMP_MOD_ATOMIC);
        APB_STAMP_writeAdc(&stamps[i],
                STAMP_REG_WRITE_DMS1 | STAMP_REG_WRITE_DMS2,
                sgrConf, // PGA and SPS
                STAMP_MOD_NONE);
        // check configuration for SGR1
        do {
            confTrials++;
            APB_STAMP_writeAdc(&stamps[i],
                    STAMP_REG_WRITE_DMS1,
                    ADS_CMD_RREG(ADS_REG_MUX1, 2),
                    STAMP_MOD_ATOMIC);
            APB_STAMP_writeAdc(&stamps[i],
                    STAMP_REG_WRITE_DMS1,
                    ADS_CMD_NOP,
                    STAMP_MOD_NONE);
            readConf = APB_STAMP_readAdc(&stamps[i], STAMP_MOD_NONE);
            if (readConf != sgrConf) {
                configflags = 1;
                 spuLog("SGR1 configuration mismatch!");
            }
        } while (readConf != sgrConf && confTrials < 3);
        confTrials = 0;
        // check configuration for SGR2
        do {
            confTrials++;
            APB_STAMP_writeAdc(&stamps[i],
                    STAMP_REG_WRITE_DMS2,
                    ADS_CMD_RREG(ADS_REG_MUX1, 2),
                    STAMP_MOD_ATOMIC);
            APB_STAMP_writeAdc(&stamps[i],
                    STAMP_REG_WRITE_DMS2,
                    ADS_CMD_NOP,
                    STAMP_MOD_NONE);
            readConf = APB_STAMP_readAdc(&stamps[i], STAMP_MOD_NONE);
            if (readConf != sgrConf) {
                configflags = 1;
                spuLog("SGR2 configuration mismatch!");
            }
        } while (readConf != sgrConf && confTrials < 3);

        // configure temperature sensor
        APB_STAMP_writeAdc(&stamps[i],
                STAMP_REG_WRITE_TEMP,
                ADS_CMD_WREG(ADS_REG_MUX0, 4),
                STAMP_MOD_ATOMIC);
        APB_STAMP_writeAdc(&stamps[i],
                STAMP_REG_WRITE_TEMP,
                0x0A00U, // ADC Pos: AIN1, ADC Neg: AIN2
                STAMP_MOD_ATOMIC);
        APB_STAMP_writeAdc(&stamps[i],
                STAMP_REG_WRITE_TEMP,
                rtdConf,
                STAMP_MOD_NONE);
        // configure temperature IDACs
        APB_STAMP_writeAdc(&stamps[i],
                STAMP_REG_WRITE_TEMP,
                ADS_CMD_WREG(ADS_REG_IDAC0, 2),
                STAMP_MOD_ATOMIC);
        APB_STAMP_writeAdc(&stamps[i],
                STAMP_REG_WRITE_TEMP,
                0x0603U, // IDAC 1mA; IDAC0: AIN0, IDAC1: AIN3
                STAMP_MOD_NONE);

        // check the temperature configuration
        confTrials = 0;
        uint32_t readTempConf = 0;
        do {
            confTrials++;
            readTempConf = 0;
            APB_STAMP_writeAdc(&stamps[i],
                    STAMP_REG_WRITE_TEMP,
                    ADS_CMD_RREG(ADS_REG_MUX0, 2),
                    STAMP_MOD_ATOMIC);
            APB_STAMP_writeAdc(&stamps[i],
                    STAMP_REG_WRITE_TEMP,
                    ADS_CMD_NOP,
                    STAMP_MOD_NONE);
            readTempConf = APB_STAMP_readAdc(&stamps[i], STAMP_MOD_NONE)
                    ^ 0x0A00U;
            if (readTempConf) {
                spuLog("TEMP configuration mismatch!");
                continue;
            }
            APB_STAMP_writeAdc(&stamps[i],
                    STAMP_REG_WRITE_TEMP,
                    ADS_CMD_RREG(ADS_REG_MUX1, 2),
                    STAMP_MOD_ATOMIC);
            APB_STAMP_writeAdc(&stamps[i],
                    STAMP_REG_WRITE_TEMP,
                    ADS_CMD_NOP,
                    STAMP_MOD_NONE);
            readTempConf = ((APB_STAMP_readAdc(&stamps[i], STAMP_MOD_NONE)
                    & 0x7FFFU) ^ rtdConf) << 16;
            APB_STAMP_writeAdc(&stamps[i],
                    STAMP_REG_WRITE_TEMP,
                    ADS_CMD_RREG(ADS_REG_IDAC0, 2),
                    STAMP_MOD_ATOMIC);
            APB_STAMP_writeAdc(&stamps[i],
                    STAMP_REG_WRITE_TEMP,
                    ADS_CMD_NOP,
                    STAMP_MOD_NONE);
            readTempConf |= ((APB_STAMP_readAdc(&stamps[i], STAMP_MOD_NONE)
                    & 0x0FFFU) ^ 0x0603U);
            if (readTempConf) {
                configflags = 1;
                spuLog("TEMP configuration mismatch!");
            }
        } while (readTempConf && confTrials < 3);
        if (configflags == 0) {
            delay(10);
            // run offset calibration
            APB_STAMP_writeAdc(&stamps[i],
                    STAMP_REG_WRITE_DMS1,
                    ADS_CMD_SYSOCAL,
                    STAMP_MOD_DATA_READY);
            delay(10);
            APB_STAMP_writeAdc(&stamps[i],
                    STAMP_REG_WRITE_DMS2,
                    ADS_CMD_SYSOCAL,
                    STAMP_MOD_DATA_READY);
            delay(10);
            APB_STAMP_writeAdc(&stamps[i],
                    STAMP_REG_WRITE_TEMP,
                    ADS_CMD_SYSOCAL,
                    STAMP_MOD_DATA_READY);
            delay(10);
            // start continuous data conversion by ADC
            APB_STAMP_writeAdc(&stamps[i],
                    STAMP_REG_WRITE_DMS1 | STAMP_REG_WRITE_DMS2 | STAMP_REG_WRITE_TEMP,
                    ADS_CMD_RDATAC,
                    STAMP_MOD_NONE);
        } else {
            configflags = 0;
        }
        MSS_WD_reload();
    }

    // enable continuous mode (on APB_STAMP) and set configuration parameters
    MSS_GPIO_set_output(OUT_ADC_START, 0);
    stamp_config_t conf = {.reset = 0, .continuous = 1, .asyncThreshold = 16,
            .empty = 0, .stampId = 0};
    for (int i = 0; i < 6; i++) {
        conf.stampId = i;
        APB_STAMP_writeConfig(&stamps[i], &conf, STAMP_MOD_NONE);
    }
    MSS_GPIO_set_output(OUT_ADC_START, 1);
}



void stampsSync (void) {
    MSS_GPIO_set_output(OUT_ADC_START, 0);
    delay(1);
    MSS_GPIO_set_output(OUT_ADC_START, 1);
}



void stampsEnableDReadyInterrupts (void) {
    for (int i = 0; i < 6; i++) {
        APB_STAMP_enableInterrupt(&stamps[i]);
    }
}
void stampsDisableDReadyInterrupts (void) {
    for (int i = 0; i < 6; i++) {
        APB_STAMP_disableInterrupt(&stamps[i]);
    }
}
void stampsSetDReadyCallback (void (*callback)(uint8_t, uint32_t, uint32_t)) {
    stampsIrqnDataAvail = callback;
}




// define the interrupt handlers
// the double layer is indeed necessary to resolve macros as arguments
#define STAMP_IRQN_NAME(num) FabricIrq##num##_IRQHandler
#define STAMP_IRQN(num) void STAMP_IRQN_NAME(num) () { \
        stampIrqn( num ); \
    }
static inline void stampIrqn (uint8_t num) {
    APB_STAMP_clearInterrupt(num);
    if (stampsIrqnDataAvail) {
        uint32_t dms12 = APB_STAMP_readDms12(&stamps[num],
                STAMP_MOD_ATOMIC);
        uint32_t tempStatus = APB_STAMP_readTempStatusRegister(&stamps[num],
                STAMP_MOD_STATUS_RESET);
        stampsIrqnDataAvail(num, dms12, tempStatus);
    }
}
STAMP_IRQN(F2M_INT_STAMP_0)
STAMP_IRQN(F2M_INT_STAMP_1)
STAMP_IRQN(F2M_INT_STAMP_2)
STAMP_IRQN(F2M_INT_STAMP_3)
STAMP_IRQN(F2M_INT_STAMP_4)
STAMP_IRQN(F2M_INT_STAMP_5)



#ifdef __cplusplus
}
#endif
