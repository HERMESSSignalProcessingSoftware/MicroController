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

static void dreadyCb(uint8_t num, uint32_t dms12, uint32_t tempReg) {
    uint8_t buf[] = { 0xAA, (dms12 >> 24) & 0xFF, (dms12 >> 16) & 0xFF, (dms12
            >> 8) & 0xFF, dms12 & 0xFF, (tempReg >> 24) & 0xFF, (tempReg >> 16)
            & 0xFF };
    MSS_UART_polled_tx(&g_mss_uart0, buf, sizeof(buf));
}

int main(void) {
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
    MSS_GPIO_config(OUT_ENA_MEMORY_CU, MSS_GPIO_OUTPUT_MODE);

    // reset the peripherals
    MSS_GPIO_set_output(OUT_RESET_N, 0);
    delay(1);
    MSS_GPIO_set_output(OUT_RESET_N, 1);

    //Disable Memory Component
    MSS_GPIO_set_output(OUT_ENA_MEMORY_CU, 0);
    ConfigStatusT CSR = { .SPIStartAddr = CSR_START_WITH_NCS1,
                          .LockCUFSM = CSR_UNLOCK_CU_FSM,
                          .PageSize = CSR_DEFAULT_PAGESIZE,
                          .StartPageNumber = 0,
                          .CurrentPageNumber = 0};
    InitMemory(CSR);
    -- Test functions you need to recreate them elsewhere
    addr_t addr = ADDR_MEMORY | MEMORY_SPI_TX_REG;
    HW_set_32bit_reg(addr, 0x12345678);
    uint32_t readBack = HW_get_32bit_reg(addr);
    uint32_t CSRvalue = HW_get_32bit_reg(ADDR_MEMORY | MEMORY_CONFIG_STATUS_REG);
    addr = ADDR_MEMORY | MEMORY_COMMAND_REG;
    uint32_t cmd = COMMAND_SPI_TRANSMIT_NCS2 << CMD_SHIFT;
    HW_set_32bit_reg(addr, cmd);
    do {
        CSRvalue = HW_get_32bit_reg(ADDR_MEMORY | MEMORY_CONFIG_STATUS_REG);
    } while (CSRvalue & (1 << 29));
    HW_set_32bit_reg(addr, COMMAND_RELOAD_SPI_TX_REG << CMD_SHIFT);
    HW_set_32bit_reg(addr, COMMAND_SPI_TRANSMIT_NCS1 << CMD_SHIFT);
    do {
        CSRvalue = HW_get_32bit_reg(ADDR_MEMORY | MEMORY_CONFIG_STATUS_REG);
    } while (CSRvalue & (1 << 29));
    CSR = ResolveBitfield(CSRvalue);
    uint32_t RXReg  = HW_get_32bit_reg(ADDR_MEMORY | MEMORY_SPI_RX_REG);
    uint32_t S1R1   = HW_get_32bit_reg(ADDR_MEMORY | MEMORY_STAMP1_REG1);
    uint32_t S1R2   = HW_get_32bit_reg(ADDR_MEMORY | MEMORY_STAMP1_REG2);
    uint32_t S2R1   = HW_get_32bit_reg(ADDR_MEMORY | MEMORY_STAMP2_REG1);
    uint32_t S2R2   = HW_get_32bit_reg(ADDR_MEMORY | MEMORY_STAMP2_REG2);
    uint32_t S3R1   = HW_get_32bit_reg(ADDR_MEMORY | MEMORY_STAMP3_REG1);
    uint32_t S3R2   = HW_get_32bit_reg(ADDR_MEMORY | MEMORY_STAMP3_REG2);
    uint32_t S4R1   = HW_get_32bit_reg(ADDR_MEMORY | MEMORY_STAMP4_REG1);
    uint32_t S4R2   = HW_get_32bit_reg(ADDR_MEMORY | MEMORY_STAMP4_REG2);
    uint32_t S5R1   = HW_get_32bit_reg(ADDR_MEMORY | MEMORY_STAMP5_REG1);
    uint32_t S5R2   = HW_get_32bit_reg(ADDR_MEMORY | MEMORY_STAMP5_REG2);
    uint32_t S6R1   = HW_get_32bit_reg(ADDR_MEMORY | MEMORY_STAMP6_REG1);
    uint32_t S6R2   = HW_get_32bit_reg(ADDR_MEMORY | MEMORY_STAMP6_REG2);
    uint32_t SA     = HW_get_32bit_reg(ADDR_MEMORY | MEMORY_STARTADDR);
    uint32_t CA     = HW_get_32bit_reg(ADDR_MEMORY | MEMORY_CURRENTADDR);
    HW_set_32bit_reg(ADDR_MEMORY | MEMORY_STARTADDR, 1000); // Set start addr to 2000
    SA     = HW_get_32bit_reg(ADDR_MEMORY | MEMORY_STARTADDR); // Read back
    uint32_t memoryPool[128] = {0};
    ReadMemory(nCS1, memoryPool, 2);
    Stamp_t stamp = {   0xFFFFFFF,0xFFFFFFF,
                        0xFFFFFFF,0xFFFFFFF,
                        0xFFFFFFF,0xFFFFFFF,
                        0xFFFFFFF,0xFFFFFFF,
                        0xFFFFFFF,0xFFFFFFF,
                        0xFFFFFFF,0xFFFFFFF};
    ReadStamps(&stamp);
    MSS_GPIO_set_output(OUT_ENA_MEMORY_CU, 1);
    // initialize the stamps
    stampsInit();
    stampsSetDReadyCallback(dreadyCb);

    uint8_t heartbeat = 0;
    for (;;) {
        // do nothing but toggle an led once in a while
        delay(500);
        CSRvalue = HW_get_32bit_reg(ADDR_MEMORY | MEMORY_CONFIG_STATUS_REG);
        heartbeat = (~heartbeat) & 1U;
        MSS_GPIO_set_output(LED_HEARTBEAT, heartbeat);

        // reset the watchdog timer to prevent hardware reset
        MSS_WD_reload();
    }

    return 0;
}
