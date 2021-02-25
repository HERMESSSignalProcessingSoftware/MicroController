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
#include "drivers/apb_stamp/apb_stamp.h"
#include "hw_platform.h"



static void delay(void);


int main (void) {
    // Initialize driver components
    SystemInit();
    MSS_WD_init();
    MSS_GPIO_init();

    // !!! move to DAPI file
    MSS_UART_init(&g_mss_uart0, MSS_UART_38400_BAUD,
            MSS_UART_DATA_8_BITS | MSS_UART_NO_PARITY | MSS_UART_ONE_STOP_BIT);

    // configure the led outputs
    MSS_GPIO_config(LED_RECORDING, MSS_GPIO_OUTPUT_MODE);
    MSS_GPIO_config(LED_HEARTBEAT, MSS_GPIO_OUTPUT_MODE);
    MSS_GPIO_set_outputs(0);

    // check, if the start of this application is the result of
    // the watchdog triggering
    if (MSS_WD_timeout_occured()) {
        // !!! log to metadata and TM
        char message[] = "Watchdog timed out";
        MSS_UART_polled_tx(&g_mss_uart0, message, sizeof(message));
    }

    apb_stamp_t test = {0};
    APB_STAMP_init(&test, ADDR_STAMP_0, F2M_INT_STAMP_0);

    for (;;) {
        // do nothing but toggle an led once in a while
        delay();
        MSS_GPIO_set_output(MSS_GPIO_31, (MSS_GPIO_get_outputs() ^ 1) & 1);

        uint32_t v = APB_STAMP_readDummy(&test, STAMP_MOD_NONE);
        APB_STAMP_writeDummy(&test, v+1, STAMP_MOD_NONE);

        // reset the watchdog timer to prevent hardware reset
        MSS_WD_reload();
    }

    return 0;
}



static void delay (void) {
    volatile uint32_t delay_count = SystemCoreClock / 128u;

    while(delay_count > 0u) {
        --delay_count;
    }
}
