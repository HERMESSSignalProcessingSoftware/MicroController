#include "../drivers/mss_timer/mss_timer.h"
#include "../drivers/mss_uart/mss_uart.h"
#include "../drivers/mss_watchdog/mss_watchdog.h"
#include "../status.h"
#include "../../drivers/apb_memory/memory.h"

static volatile uint32_t delayCompleted = 0;
static volatile uint32_t delayCounter = 0;

static volatile uint32_t heartbeatCounter = 0;
static volatile uint32_t heartbeatValue = 0;

void Timer1_IRQHandler () {
    if ((--delayCounter) < 1)
        delayCompleted = 1;
    MSS_TIM1_clear_irq();
}

void Timer2_IRQHandler() {
    if ((--heartbeatCounter) == 0) {
        mssSignals |= TIM2_HEARTBEAT_SIGNAL;
        heartbeatCounter = heartbeatValue;
    }
    MSS_TIM2_clear_irq();
}

void InitHeartbeat(uint32_t delay) {
    heartbeatValue = delay;
    heartbeatCounter = delay;
    MSS_TIM2_init(MSS_TIMER_PERIODIC_MODE);
    MSS_TIM2_load_immediate(100000); //1ms @ 100MHz
    MSS_TIM2_enable_irq();
    MSS_TIM2_start();
}
void StopHeartbeat(void) {
    MSS_TIM2_disable_irq();
    MSS_TIM2_stop();
}
void delay (uint32_t ms) {
    delayCompleted = 0;
    delayCounter = ms;
    MSS_TIM1_init(MSS_TIMER_PERIODIC_MODE);
    MSS_TIM1_load_immediate(100000); // 1ms @100MHz
    MSS_TIM1_enable_irq();
    MSS_TIM1_start();
    while (delayCompleted == 0) {
        MSS_WD_reload();
    }
    MSS_TIM1_stop();
}



void ResetBuffer(uint8_t *ptr, uint32_t value, uint32_t size) {
    for (uint32_t i = 0; i < size; i++) {
        *(ptr++) = value;
    }
}

/**
 * Tests the Metaaddress update algorithm
 *
 * @param dev SPI_Value the device to be used as meta data storage
 * @return 0 if ok, > 0 for each error in 64 values written
 */
uint32_t TestMetaWriter(SPI_Values dev) {
    uint8_t buffer[PAGESIZE] = { 0 };
    uint32_t *ptr = (uint32_t*)buffer;
    uint32_t result = 0;
    uint32_t pageNumber = 0;
    for (uint32_t i = 1; i <= 64; i++) {
        /* Write value to memory */
        pageNumber = UpdateMetadata(i, dev);
        /* Wait until page is valid */
        writeReady(dev);
        /* Read back the page */
        readPage(buffer, pageNumber, dev);
        if (*ptr != i) {
            result++;
        }
        ptr++;
        ResetBuffer(buffer, 0, PAGESIZE);
    }
    return result;

}

void spuLog (char message[]) {
    MSS_UART_polled_tx_string(&g_mss_uart0, message);
}
