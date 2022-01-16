/* HERMESS Software V. 0.0.1
 *
 * Supporting DAPI Spec. 0.0.1
 * Supporting TM Spec. 0.0.1
 */

#include <stdint.h>
#include "sb_hw_platform.h"
#include "status.h"
#include "CMSIS/system_m2sxxx.h"
#include "drivers/mss_watchdog/mss_watchdog.h"
#include "drivers/mss_gpio/mss_gpio.h"
#include "components/tools.h"
#include "components/stamps.h"
#include "components/dapi.h"
#include "components/telemetry.h"
#include "drivers/apb_memory/memory.h"
#include "drivers/mss_spi/mss_spi.h"
#include "components/HERMESS.h"


/**
 * @brief Use this 32 bit value to add the missing three bits into the SR1 from the fabric before saving them.
 */
static volatile uint32_t StatusRegisterLocals = 0x0;
uint32_t mssSignals = 0;
/**
 * SODS: T - 120s <-> T + 500s = 620s  (critical)
 * SOE: T - 180s <-> T + 500s = 680s
 * LO: T = 0 <-> T + 500s = 500s
 *
 */
/**
 * TODO:
 * - Implement LED_FPGA_LOADED behaviour
 * - Test telemetry, 19200 BAUD, 8n1
 * - Implement SOE / LO handling
 * - Fix VHDL Stamp component
 * - Stamp1 SGR 1 failing
 * - Stamp2 SGR 1 missing
 * */
int main (void) {
    uint32_t telemetryCounter = 0;
    uint8_t *telemetryFramePtr = (uint8_t*)(&telemetryFrame);
    uint32_t memSyncHeartbeatValue = 1;
    // Initialize driver components
    //SystemInit();
    MSS_WD_init();
    MSS_GPIO_init();

    // initialize the DAPI
    dapiInit();
    delay(1);
    InitTelemetry();
    // check, if the start of this application is the result of
    // the watchdog triggering
    MSS_WD_enable_timeout_irq(); // just for debugging using timeouts instead of resets
    if (MSS_WD_timeout_occured()) {
        MSS_WD_clear_timeout_event();
        spuLog("Watchdog timed out\n");
    }

    // configure the GPIOs
    MSS_GPIO_set_outputs(0);
    MSS_GPIO_config(OUT_RESET_N, MSS_GPIO_OUTPUT_MODE);
    MSS_GPIO_config(LED_RECORDING, MSS_GPIO_OUTPUT_MODE);
    MSS_GPIO_config(LED_HEARTBEAT, MSS_GPIO_OUTPUT_MODE);
    MSS_GPIO_config(LED_HEARTBEAT_MEMSYNC, MSS_GPIO_OUTPUT_MODE);
    MSS_GPIO_config(LED_FPGA_LOADED, MSS_GPIO_OUTPUT_MODE);
    MSS_GPIO_config(FLASH_CS1, MSS_GPIO_OUTPUT_MODE);
    MSS_GPIO_config(FLASH_CS2, MSS_GPIO_OUTPUT_MODE);
    MSS_GPIO_config(OUT_ENABLE_MEM_SYNC, MSS_GPIO_OUTPUT_MODE);
    MSS_GPIO_config(IN_RXSM_LO, MSS_GPIO_INPUT_MODE | MSS_GPIO_IRQ_EDGE_BOTH);
    MSS_GPIO_config(IN_RXSM_SODS, MSS_GPIO_INPUT_MODE | MSS_GPIO_IRQ_EDGE_BOTH);
    MSS_GPIO_config(IN_RXSM_SOE, MSS_GPIO_INPUT_MODE | MSS_GPIO_IRQ_EDGE_BOTH);

    /* Enable GPIO Irqs */
    MSS_GPIO_enable_irq(IN_RXSM_LO);
    MSS_GPIO_enable_irq(IN_RXSM_SODS);
    MSS_GPIO_enable_irq(IN_RXSM_SOE);
    /* Set up LEDS */
    MSS_GPIO_set_output(LED_HEARTBEAT_MEMSYNC, 1);
    MSS_GPIO_set_output(LED_FPGA_LOADED, 1);
    // reset the peripherals
    MSS_GPIO_set_output(OUT_RESET_N, 0);
    delay(1);
    MSS_GPIO_set_output(OUT_RESET_N, 1);
    // run the memory test
    InitMemorySynchronizer(DO_NOT_ERASE, AUTO_START_OFF);
    //FastMemoryTest();
    MemoryConfig MemConfig = Recovery();
    /*Should not be happen, recovery shall configure the struct correctly*/
    if (MemConfig.RecoverySuccess == 0) {
        MemConfig.StartPage = START_OF_DATA_SEGMENT;
        MemConfig.CurrentPage = START_OF_DATA_SEGMENT;
        MemConfig.MetaAddress = START_OF_META_SEGMENT;
        MemConfig.StartChipSelect = FLASH_CS1;
        MemConfig.CurrentChipSelect = FLASH_CS1;
    }

    // initialize the stamps
    // SGR: PGA 64 @ 1kSPS
    // RTD: PGA 16 @ 20SPS
    stampsInit(STAMPS_PGA_64, STAMPS_SPS_1000, STAMPS_PGA_16, STAMPS_SPS_20);

    uint8_t heartbeat = 0;
    SPI_Values device;
    device.CS_Pin = MemConfig.StartChipSelect;
    device.spihandle = &g_mss_spi0;
    SPI_Values metaDevice;
    metaDevice.CS_Pin = FLASH_CS1;
    metaDevice.spihandle = &g_mss_spi0;

    InitHeartbeat(1000); //heartbeat at 1s
    spuLog("Init DONE!\n");
    MSS_GPIO_set_output(LED_HEARTBEAT_MEMSYNC, 0);
    for (;;) {
        if (mssSignals & MSS_SIGNAL_SOE) {
            StatusRegisterLocals |= (MSS_SIGNAL_SOE);
            mssSignals &= ~( MSS_SIGNAL_SOE);
            telemetryFrame.statusReg1 |= StatusRegisterLocals;
            mssSignals |= MSS_SIGNAL_TELEMETRY;
        }
        if (mssSignals & MSS_SIGNAL_SOE_RESET) {
            StatusRegisterLocals &= ~(MSS_SIGNAL_SOE);
            mssSignals &= ~( MSS_SIGNAL_SOE_RESET);
            telemetryFrame.statusReg1 &= ~(StatusRegisterLocals);
        }
        /*Start recording here*/
        if ((mssSignals & MSS_SIGNAL_SODS)) {
            mssSignals &= ~(MSS_SIGNAL_SODS);
            StatusRegisterLocals |=  (MSS_SIGNAL_SODS);
            StartMemorySync();
            MSS_GPIO_set_output(LED_RECORDING, 1);
            delay(1);
        }
        /* Stop action here */
        if ((mssSignals & MSS_SIGNAL_SODS_RESET)) {
            mssSignals &= ~(MSS_SIGNAL_SODS_RESET);
            StatusRegisterLocals &= ~(MSS_SIGNAL_SODS);
            StopMemorySync();
            MSS_GPIO_set_output(LED_RECORDING, 0);
            writeReady(metaDevice);
            MemConfig.MetaAddress = UpdateMetadata(MemConfig.CurrentPage, MemConfig.MetaAddress, metaDevice);
            delay(1);
        }

        if (mssSignals & MSS_SIGNAL_DAPI_CMD) {
           // mssSignals &= ~(MSS_SIGNAL_DAPI_CMD);
            dapiExecutePendingCommand();
        }

        /* Ignored LO signal does nothing */
        if (mssSignals & MSS_SIGNAL_LO) {
            StatusRegisterLocals |= (MSS_SIGNAL_LO);
            mssSignals &= ~(MSS_SIGNAL_LO);
        }
        if (mssSignals & MSS_SIGNAL_LO_RESET) {
            StatusRegisterLocals &= ~(MSS_SIGNAL_LO);
            mssSignals &= ~( MSS_SIGNAL_LO_RESET);
        }
//
        /*Write Meta data to FLASH_CS1 connected device*/
        if ((mssSignals & MSS_SIGNAL_UPDATE_META)
                && ((mssSignals & MSS_SIGNAL_SPI_WRITE) == 0)) {
            /* Make sure you dont violate any memory above the start address
             *
             * Its very unlikely to do that in a about 800s time space
             * */
            if (MemConfig.MetaAddress < START_OF_DATA_SEGMENT) {
                writeReady(metaDevice);
                MemConfig.MetaAddress = UpdateMetadata(MemConfig.CurrentPage, MemConfig.MetaAddress, metaDevice);
                /* Memory synchronizer LED */
                MSS_GPIO_set_output(LED_HEARTBEAT_MEMSYNC, memSyncHeartbeatValue);
                memSyncHeartbeatValue = ~(memSyncHeartbeatValue);
            }
            mssSignals &= ~(MSS_SIGNAL_UPDATE_META);
        }

        if (mssSignals & MSS_MEMORY_ERASE) {
            MemConfig.CurrentChipSelect = FLASH_CS1;
            MemConfig.CurrentPage = START_OF_DATA_SEGMENT;
            MemConfig.StartPage = START_OF_DATA_SEGMENT;
            device.CS_Pin = FLASH_CS1;
            mssSignals &= ~(MSS_MEMORY_ERASE);
        }
        /*Write data to device*/
        if ((mssSignals & MSS_SIGNAL_SPI_WRITE)
                || (mssSignals & MSS_SIGNAL_WRITE_AND_KILL)) {
            writeReady(device);
            writePage(MemoryPtr, PAGEADDR(MemConfig.CurrentPage), device);
            if (MemConfig.CurrentChipSelect == FLASH_CS2) {
                MemConfig.CurrentPage++;
                MemConfig.CurrentChipSelect = FLASH_CS1;
                device.CS_Pin = FLASH_CS1;
            } else if (MemConfig.CurrentChipSelect == FLASH_CS1) {
                MemConfig.CurrentChipSelect = FLASH_CS2;
                device.CS_Pin = FLASH_CS2;
            }

            /* Just reset a signal bit */
            mssSignals &= ~(MSS_SIGNAL_SPI_WRITE);
            if (mssSignals & MSS_SIGNAL_WRITE_AND_KILL) {
                /*Note: MetaAddress is the page counter >> 9*/
                if (MemConfig.MetaAddress < MemConfig.StartPage) {
                    /* TODO: implement and test killing behaviour*/
                }
                    /*Write32Bit(MemConfig.CurrentPage, MemConfig.MetaAddress,
                            metaDevice);*/
                /* Request killing the system */
                // !!! TODO: Kill system here
            }
            /* Count every page ld(250000) approx 18 */
            MemoryDatasetCounter++;
        }

        if (mssSignals & MSS_SIGNAL_TELEMETRY) {
            uint8_t *localPtr = (uint8_t*)&telemetryFrame;
            while((mssSignals & MSS_SIGNAL_SPI_WRITE) == 0 && ((telemetryCounter) <= (FRAMESIZE - 1))) {
                uint8_t value = localPtr[telemetryCounter++];
                TransmitByte(value);
            }
            if (telemetryCounter >= (FRAMESIZE - 1)) {
                SetMemory((uint8_t*)&telemetryFrame, 0, sizeof(Telemmetry_t));
                mssSignals &= ~(MSS_SIGNAL_TELEMETRY);
                telemetryCounter = 0;
            }
        }
//
        // do nothing but toggle an led once in a while
        if (mssSignals & TIM2_HEARTBEAT_SIGNAL) {
            heartbeat = (~heartbeat) & 1U;
            MSS_GPIO_set_output(LED_HEARTBEAT, heartbeat);
            mssSignals &= ~(TIM2_HEARTBEAT_SIGNAL);
        }
        // reset the watchdog timer to prevent hardware reset
        MSS_WD_reload();
    }

    return 0;
}

// Handle Interrupts
void FabricIrq0_IRQHandler(void) {
    /*At first read all data */
    uint32_t SR1 = CopyDataFabricToMaster(MemoryPtr, &telemetryFrame,  StatusRegisterLocals);
    uint32_t CR = HW_get_32bit_reg(MEMORY_REG(ConfigReg));
    if (SR1 & PENDING_SYNCHRONIZER_INTERRUPT) {
        mssSignals |= (MSS_SIGNAL_WRITE_AND_KILL);
        // Do the REset here
        /* TODO in this case
         * - Save the started page and the last registers to flash mem
         * - Save current nCS line and current Page addr to 1. Page (STARTADDR) on FLASH_CS1
         * - Trigger Reset
         * - after reset, read StartAddrs page, restore address offset
         * - Do normal start up
         * - Continue writing
         * */
        /* NOT tested yet */
        NVIC_SystemReset();
    }

    if (SR1 & PENDING_READ_INTERRUPT) {
        MemoryInterruptCounter++; /* Count the number of interrupts */
        if (MemoryInterruptCounter % 8 == 0) { /* Just save the content to SPI Memory by ... it to the main process*/
            mssSignals |= MSS_SIGNAL_SPI_WRITE;
            MemoryPtrWatermark32Bit = 0; /* ! Reset the watermark to prevent a buffer overflow */

        }
        if (MemoryInterruptCounter % 40 == 0) {
            mssSignals |= MSS_SIGNAL_TELEMETRY;

        }
        if (MemoryInterruptCounter >= 1000) {
            mssSignals |= MSS_SIGNAL_UPDATE_META;
            MemoryInterruptCounter = 1;
        }
    }
    if (SR1 & PENDING_APB_ADDRESS_ERROR) {
        HW_set_32bit_reg(MEMORY_REG(SynchStatusReg), 0x00); // Just write something to the SR Register (it does not care about the content)
    }
    /* Clear Status Register and Interrupts by writing a 1 to CR(30 | 29) */
    CR |= CONFIG_REG_CLEAR_READ_INTERRUPT;
    HW_set_32bit_reg(MEMORY_REG(ConfigReg), CR);
    HW_set_32bit_reg(MEMORY_REG(SynchStatusReg), 0x00); // Just write something to the SR Register (it does not care about the content)
    NVIC_ClearPendingIRQ(MEMORY_SYNC_IRQn);
}


/**
 * ISR: Will be called whenever a change of the RXSM-LO Signal occurs
 * and sets the appropriate flag for the main execution loop
 */
void GPIO_HANDLER(IN_RXSM_LO) (void) {
    if (MSS_GPIO_get_inputs() & (1 << IN_RXSM_LO)) {
        mssSignals |= MSS_SIGNAL_LO_RESET;
    } else {
        mssSignals |= MSS_SIGNAL_LO;
    }
    MSS_GPIO_clear_irq(IN_RXSM_LO);
}


/**
 * ISR: Will be called whenever a change of the RXSM-SODS Signal occurs
 * and sets the appropriate flag for the main execution loop
 */
void GPIO_HANDLER(IN_RXSM_SODS) (void) {
    if (MSS_GPIO_get_inputs() & (1 << IN_RXSM_SODS)) {
        mssSignals |= MSS_SIGNAL_SODS_RESET;
        mssSignals |= MSS_SIGNAL_UPDATE_META;
    } else {
        mssSignals |= MSS_SIGNAL_SODS;
    }
    MSS_GPIO_clear_irq(IN_RXSM_SODS);
}


/**
 * ISR: Will be called whenever a change of the RXSM-SOE Signal occurs
 * and sets the appropriate flag for the main execution loop
 */
void GPIO_HANDLER(IN_RXSM_SOE) (void) {
    if (MSS_GPIO_get_inputs() & (1 << IN_RXSM_SOE)) {
        mssSignals |= MSS_SIGNAL_SOE_RESET;
        mssSignals |= MSS_SIGNAL_UPDATE_META;
    } else {
        mssSignals |= MSS_SIGNAL_SOE;
    }
    MSS_GPIO_clear_irq(IN_RXSM_SOE);
}


void NMI_Handler (void) {
    MSS_WD_clear_timeout_irq();
}



