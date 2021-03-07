#include "../drivers/mss_timer/mss_timer.h"
#include "../drivers/mss_uart/mss_uart.h"
#include "../drivers/mss_watchdog/mss_watchdog.h"


static volatile uint32_t delayCompleted = 0;
void Timer1_IRQHandler () {
    delayCompleted--;
    MSS_TIM1_clear_irq();
}
void delay (uint32_t ms) {
    delayCompleted = ms;
    MSS_TIM1_init(MSS_TIMER_PERIODIC_MODE);
    MSS_TIM1_load_immediate(100000); // 1ms @100MHz
    MSS_TIM1_enable_irq();
    MSS_TIM1_start();
    while (delayCompleted) {
        MSS_WD_reload();
    }
    MSS_TIM1_stop();
}


void spuLog (char message[]) {
    MSS_UART_polled_tx_string(&g_mss_uart0, message);
}
