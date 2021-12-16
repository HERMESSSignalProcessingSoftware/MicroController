/*
 * tm.c
 *
 *  Created on: 26.06.2021
 *      Author: Robin Grimsmann
 */

#include "telemetry.h"
#include "../status.h"
#include "../drivers/mss_uart/mss_uart.h"

Telemmetry_t telemetryFrame = { 0 };

static void telemetryRxHandler (mss_uart_instance_t *this_uart) {

}

void InitTelemetry(void) {
    MSS_UART_init(&g_mss_uart1, MSS_UART_19200_BAUD,
            MSS_UART_DATA_8_BITS | MSS_UART_NO_PARITY | MSS_UART_ONE_STOP_BIT);
    MSS_UART_set_tx_endian(&g_mss_uart1, MSS_UART_LITTLEEND);
    MSS_UART_set_rx_handler(&g_mss_uart1, telemetryRxHandler,
                MSS_UART_FIFO_SINGLE_BYTE);
}

/*TODO: Fix retrun value! */
uint32_t TransmitByte(uint8_t byte) {
    MSS_UART_polled_tx(&g_mss_uart1, &byte, 1);
    return 0;
}
