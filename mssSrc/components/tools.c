#include "../drivers/mss_timer/mss_timer.h"
#include "../drivers/mss_uart/mss_uart.h"
#include "../drivers/mss_watchdog/mss_watchdog.h"
#include "../drivers/apb_memory/MemoryRev2.h"

static volatile uint32_t delayCompleted = 0;

static volatile uint32_t delayCompleted_Tim2 = 0;
static volatile uint32_t SetValue;

void Timer2_IRQHandler() {
    delayCompleted_Tim2--;
    if (delayCompleted_Tim2 == 0) {
        delayCompleted_Tim2 = SetValue;
        MSS_SIGNALS |= TIM2_HEARTBEAT_SIGNAL;
    }
    MSS_TIM2_clear_irq();
}

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

void SetHeartbeatPeriode(uint32_t periode) {
    SetValue = periode;
    delayCompleted_Tim2 = periode;
    MSS_TIM2_init(MSS_TIMER_PERIODIC_MODE);
    MSS_TIM2_load_immediate(100000); // 1ms @100MHz
    MSS_TIM2_clear_irq();
    MSS_TIM2_enable_irq();
    MSS_TIM2_start();
}

void spuLog (char message[]) {
    MSS_UART_polled_tx_string(&g_mss_uart0, message);
}
