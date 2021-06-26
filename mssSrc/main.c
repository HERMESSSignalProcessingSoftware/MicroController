/* HERMESS Software V. 0.0.1
 *
 * Supporting DAPI Spec. 0.0.1
 * Supporting TM Spec. 0.0.1
 */

#include <stdint.h>
#include "CMSIS/system_m2sxxx.h"
#include "drivers/mss_watchdog/mss_watchdog.h"
#include "drivers/mss_uart/mss_uart.h"
#include "drivers/mss_gpio/mss_gpio.h"
#include "components/tools.h"
#include "components/stamps.h"
#include "hw_platform.h"
#include "drivers/apb_memory/MemoryRev2.h"
#include "drivers/mss_spi/mss_spi.h"
#include "components/HERMESS.h"

/**
 * @brief Use this 32 bit value to add the missing three bits into the SR1 from the fabric befor saving them.
 */
uint32_t volatile StatusRegisterLocals = 0x0;

static void dreadyCb(uint8_t num, uint32_t dms12, uint32_t tempReg) {
    uint8_t buf[] = { 0xAA, (dms12 >> 24) & 0xFF, (dms12 >> 16) & 0xFF, (dms12
            >> 8) & 0xFF, dms12 & 0xFF, (tempReg >> 24) & 0xFF, (tempReg >> 16)
            & 0xFF };

    MSS_UART_polled_tx(&g_mss_uart0, buf, sizeof(buf));
}

int main(void) {
    uint32_t csr = 0;
    // Initialize driver components
    SystemInit();
    MSS_WD_init();
    MSS_GPIO_init();

    // !!! move to DAPI file
    MSS_UART_init(&g_mss_uart0, MSS_UART_115200_BAUD,
    MSS_UART_DATA_8_BITS | MSS_UART_NO_PARITY | MSS_UART_ONE_STOP_BIT);
    MSS_UART_set_tx_endian(&g_mss_uart0, MSS_UART_LITTLEEND);

    // check, if the start of this application is the result of
    // the watchdog triggering
    if (MSS_WD_timeout_occured())
        spuLog("Watchdog timed out");

    // configure the GPIOs
    MSS_GPIO_set_outputs(0);
    MSS_GPIO_config(OUT_RESET_N, MSS_GPIO_OUTPUT_MODE);
    MSS_GPIO_config(LED_RECORDING, MSS_GPIO_OUTPUT_MODE);
    MSS_GPIO_config(LED_HEARTBEAT, MSS_GPIO_OUTPUT_MODE);
    MSS_GPIO_config(nCS1, MSS_GPIO_OUTPUT_MODE);
    MSS_GPIO_config(nCS2, MSS_GPIO_OUTPUT_MODE);
    MSS_GPIO_config(OUT_ENABLE_MEM_SYNC, MSS_GPIO_OUTPUT_MODE);

    // reset the peripherals
    MSS_GPIO_set_output(OUT_RESET_N, 0);
    delay(1);
    MSS_GPIO_set_output(OUT_RESET_N, 1);

    /* Config the heartbeat duration */
    SetHeartbeatPeriode(500);
    /* run the memory test */
    InitMemorySynchronizer(DO_NOT_ERASE, AUTO_START_ON);


    MemoryConfig MemConfig = Recovery();
    if (!MemConfig.RecoverySuccess) {
        asm volatile ("nop");
    }
    MemConfig.StartPage = 0x200;
    MemConfig.CurrentPage = 0x200;
    MemConfig.StartChipSelect = nCS1;
    MemConfig.CurrentChipSelect = nCS1;
    MemConfig.MetaAddress = 0x0;
    // initialize the stamps
    stampsInit();

    //stampsSetDReadyCallback(dreadyCb);
    uint8_t heartbeat = 0;
    SPI_Values device;
    device.CS_Pin = MemConfig.StartChipSelect;
    device.spihandle = &g_mss_spi0;
    SPI_Values metaDevice;
    metaDevice.CS_Pin = nCS1;
    metaDevice.spihandle = &g_mss_spi0;
    for (;;) {

        /*
         * TODO: Hanlde these signals
         *
         * */
        if (MSS_SIGNALS & MSS_SIGNAL_SODS) {
            StatusRegisterLocals |= (MSS_SIGNAL_SODS);
            MSS_SIGNALS &= ~(MSS_SIGNAL_SODS);
        }
        if (MSS_SIGNALS & MSS_SIGNAL_SOE) {
            MSS_GPIO_set_output(OUT_ENABLE_MEM_SYNC, 1); // From this point forward the Farbric0 Interrupt will be coming and data will be stored
            StatusRegisterLocals |= (MSS_SIGNAL_SOE);
            MSS_SIGNALS &= ~(MSS_SIGNAL_SOE);
        }
        if (MSS_SIGNALS & MSS_SIGNAL_LO) {
            StatusRegisterLocals |= (MSS_SIGNAL_LO);
            MSS_SIGNALS &= ~(MSS_SIGNAL_LO);
        }
        if ((MSS_SIGNALS & MSS_SIGNAL_UPDATE_META)
                && ((MSS_SIGNALS & MSS_SIGNAL_SPI_WRITE) == 0)) {
            /* Make sure you dont violate any memory above the start addreess
             *
             * Its very unlikely to to hat in a about 800s time space
             * */
            if (MemConfig.MetaAddress < MemConfig.StartPage)
                Write32Bit(MemConfig.CurrentPage, MemConfig.MetaAddress, metaDevice);

            MemConfig.MetaAddress += 4;
            MSS_SIGNALS &= ~(MSS_SIGNAL_UPDATE_META);
        }

        if ((MSS_SIGNALS & MSS_SIGNAL_SPI_WRITE) ||
                (MSS_SIGNALS & MSS_SIGNAL_WRITE_AND_KILL)) {
            writePage(MemoryPtr, MemConfig.CurrentPage, device);
            if (MemConfig.CurrentChipSelect == nCS2) {
                MemConfig.CurrentPage++;
                MemConfig.CurrentChipSelect = nCS1;
                device.CS_Pin = nCS1;
            } else if (MemConfig.CurrentChipSelect == nCS1) {
                MemConfig.CurrentChipSelect = nCS2;
                device.CS_Pin = nCS2;
            }
            /* Just reset a signal bit */
            MSS_SIGNALS &= ~(MSS_SIGNAL_SPI_WRITE);
            if (MSS_SIGNALS & MSS_SIGNAL_WRITE_AND_KILL) {
                if (MemConfig.MetaAddress < MemConfig.StartPage)
                    Write32Bit(MemConfig.CurrentPage, MemConfig.MetaAddress, metaDevice);
                /* Request killing the system */

                //SCB_AIRCR_ =
            }
        }

        if (MSS_SIGNALS & MSS_SIGNAL_TELEMETRY) {
            /*
             * TODO: Transmit data to Earth here
             * Be careful! Do not transmit all the data at once,
             * it may blocks the loop here and signals with higher
             * priority will be left unseen causing a critical delay
             *
             * Lets assume Tbit = 33us (boi its long)
             */
            MSS_SIGNALS &= ~(MSS_SIGNAL_TELEMETRY);
        }

        // do nothing but toggle an led once in a while
        if (MSS_SIGNALS & TIM2_HEARTBEAT_SIGNAL) {
            heartbeat = (~heartbeat) & 1U;
            MSS_GPIO_set_output(LED_HEARTBEAT, heartbeat);
            MSS_SIGNALS &= ~(TIM2_HEARTBEAT_SIGNAL);
        }
        // reset the watchdog timer to prevent hardware reset
        MSS_WD_reload();
    }

    return 0;
}

// Handle Interrupts
void FabricIrq0_IRQHandler(void) {
    /*At first read all data */
    uint32_t SR1 = CopyDataFabricToMaster(MemoryPtr, StatusRegisterLocals);
    uint32_t CR = HW_get_32bit_reg(MEMORY_REG(ConfigReg));
    if (SR1 & PENDING_SYNCHRONIZER_INTERRUPT) {
        MSS_SIGNALS |= (MSS_SIGNAL_WRITE_AND_KILL);
        // Do the REset here
        /* TODO in this case
         * - Save the started page and the last registers to flash mem
         * - Save current nCS line and current Page addr to 1. Page (STARTADDR) on nCS1
         * - Trigger Reset
         * - after reset, read StartAddrs page, restore address offset
         * - Do normal start up
         * - Continue writing
         * */
    }
    if (SR1 & PENDING_READ_INTERRUPT) {
        MemoryInterruptCounter++; /* Count the number of interrupts */
        if (MemoryInterruptCounter % 8 == 0) { /* Just save the content to SPI Memory by ... it to the main process*/
            MSS_SIGNALS |= MSS_SIGNAL_SPI_WRITE;
            MemoryPtrWatermark32Bit = 0; /* ! Reset the watermark to prevent a buffer overflow */

        } else if (MemoryInterruptCounter % 33 == 0) {
            MSS_SIGNALS |= MSS_SIGNAL_TELEMETRY;

        } else if (MemoryInterruptCounter == 67) {
            MSS_SIGNALS |= MSS_SIGNAL_UPDATE_META;
            MemoryInterruptCounter = 1;
        }

        /* TODO:
         * - save updated current page value to memory if telemetry is hitting.
         *
         * */
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
