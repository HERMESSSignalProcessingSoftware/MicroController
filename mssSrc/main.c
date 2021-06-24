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
#include "drivers/apb_memory/memory.h"
#include "drivers/apb_memory/MemoryRev2.h"
#include "drivers/mss_spi/mss_spi.h"

static void dreadyCb(uint8_t num, uint32_t dms12, uint32_t tempReg) {
    uint8_t buf[] = { 0xAA, (dms12 >> 24) & 0xFF, (dms12 >> 16) & 0xFF, (dms12
            >> 8) & 0xFF, dms12 & 0xFF, (tempReg >> 24) & 0xFF, (tempReg >> 16)
            & 0xFF };
    /* Example of how to read the data from the shadow regs if neccessary (telemetry) */
    uint32_t S1R1 = HW_get_32bit_reg(ADDR_MEMORY | MEMORY_STAMP1_REG1);
    uint32_t S1R2 = HW_get_32bit_reg(ADDR_MEMORY | MEMORY_STAMP1_REG2);
    /* END OF EXAMPLE */
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

    /* Init SPI for Memory usage */




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

    /* run the memory test */
    InitSPIMemory();

    //FastMemoryTest();

    // reset the peripherals
    MSS_GPIO_set_output(OUT_RESET_N, 0);
    delay(1);
    MSS_GPIO_set_output(OUT_RESET_N, 1);


    // initialize the stamps
    //stampsInit();

    //stampsSetDReadyCallback(dreadyCb);
    uint8_t heartbeat = 0;
    for (;;) {
        // do nothing but toggle an led once in a while
        delay(500);
        //CSRvalue = HW_get_32bit_reg(ADDR_MEMORY | MEMORY_CONFIG_STATUS_REG);
        heartbeat = (~heartbeat) & 1U;
        MSS_GPIO_set_output(LED_HEARTBEAT, heartbeat);

        // reset the watchdog timer to prevent hardware reset
        MSS_WD_reload();
    }

    return 0;
}

