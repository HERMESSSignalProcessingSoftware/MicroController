#ifdef __cplusplus
extern "C" {
#endif

#include "dapi.h"
#include "../status.h"
#include "../drivers/mss_uart/mss_uart.h"
#include "../drivers/apb_memory/memory.h"
#include "HERMESS.h"
#include "tools.h"

#define DAPI_RX_BUFF_SIZE 64



static uint8_t rxBuff[DAPI_RX_BUFF_SIZE] = {0};
static uint8_t rxIdx = 0;
static void dapiUartRxHandler (mss_uart_instance_t *this_uart) {
    // usually read a single byte
    // probably results in deadlocks, once the rxBuff is filled, therefore
    // proper specification adhesion is advised
    rxIdx += MSS_UART_get_rx(this_uart, &rxBuff[rxIdx],
            DAPI_RX_BUFF_SIZE - rxIdx);

    // signal the receival of a DAPI command, when end of transmission sensed
    if (rxIdx > 2 && rxBuff[rxIdx-2] == 0x17U && rxBuff[rxIdx-1] == 0xF0U)
        mssSignals |= MSS_SIGNAL_DAPI_CMD;
}



void dapiInit (void) {
    MSS_UART_init(&g_mss_uart0, MSS_UART_921600_BAUD,
            MSS_UART_DATA_8_BITS | MSS_UART_NO_PARITY | MSS_UART_ONE_STOP_BIT);
    MSS_UART_set_tx_endian(&g_mss_uart0, MSS_UART_LITTLEEND);
    MSS_UART_set_rx_handler(&g_mss_uart0, dapiUartRxHandler,
            MSS_UART_FIFO_SINGLE_BYTE);
}



void dapiExecutePendingCommand (void) {
    SPI_Values device;
    device.CS_Pin = FLASH_CS1;
    device.spihandle = &g_mss_spi0;
    uint8_t buffer[PAGESIZE] = { 0 };
    if (rxIdx && (mssSignals & MSS_SIGNAL_DAPI_CMD)) {
        switch (rxBuff[0]) {
        case 0x01: {
            uint32_t pages = PAGE_COUNT;
            uint8_t txBuff[] = { 0x01,
                                 (pages & 0xFF000000) >> 24,
                                 (pages & 0x00FF0000) >> 16,
                                 (pages & 0x0000FF00) >> 8,
                                 (pages & 0x000000FF)};
            uint8_t txEndBuffer[] = {0x0F, 0x17, 0xF0};
            MSS_UART_polled_tx(&g_mss_uart0, txBuff, 5);
            //!!! TODO: Determine maximal page count before writing everything to serial interface
            for (int address = 0x200; address < PAGE_COUNT; address++) {
                device.CS_Pin = FLASH_CS1;
                readPage(buffer, address, device);
                MSS_UART_polled_tx(&g_mss_uart0, buffer, PAGESIZE);
                device.CS_Pin = FLASH_CS2;
                readPage(buffer, address, device);
                MSS_UART_polled_tx(&g_mss_uart0, buffer, PAGESIZE);
            }
            MSS_UART_polled_tx(&g_mss_uart0, txEndBuffer, 3);
            // answer the request with the response
            } break;
        case 0x02: { // Read until,
            uint32_t pagesPerChip = (rxBuff[1] << 24) | (rxBuff[2] << 16) |
                             (rxBuff[3] << 8)  | (rxBuff[4]);
            uint8_t answer[] = {0x02, 0xFF, 0xFF, 0xFF, 0xFF, 0x17, 0xF0};
            for (uint32_t i = 0; i < pagesPerChip; i++) {
                device.CS_Pin = FLASH_CS1;
                readPage(buffer, 0x200 + i, device);
                MSS_UART_polled_tx(&g_mss_uart0, buffer, PAGESIZE);
                device.CS_Pin = FLASH_CS2;
                readPage(buffer, 0x200 + i, device);
                MSS_UART_polled_tx(&g_mss_uart0, buffer, PAGESIZE);
            }
            MSS_UART_polled_tx(&g_mss_uart0, answer, 7);
        } break;
        case 0x20: {
            uint8_t test = (uint8_t)(FastTest(device)) << 1;
            device.CS_Pin = FLASH_CS2;
            test |= (uint8_t)(FastTest(device));
            uint8_t txBuffer[] = {0x20, 0x0, 0x0, 0x0, 0x1, 0x0, 0x0F, 0x17, 0xF0 };
            txBuffer[5] = test;
            MSS_UART_polled_tx(&g_mss_uart0, txBuffer, 9);
        } break;
        case 0x11: //meta
        {
            uint8_t answer[] = {0x11, 0x0, 0x0, 0x0, 0x1, 0x0, 0x0, 0x0, 0x0, 0x0F, 0x17, 0xF0}; //#12
            MemoryConfig MemConfig = Recovery();
            answer[5] = (uint8_t)((MemConfig.CurrentPage & 0xFF000000) >> 24);
            answer[6] = (uint8_t)((MemConfig.CurrentPage & 0x00FF0000) >> 16);
            answer[7] = (uint8_t)((MemConfig.CurrentPage & 0x0000FF00) >> 8);
            answer[8] = (uint8_t)(MemConfig.CurrentPage  & 0x000000FF);
            MSS_UART_polled_tx(&g_mss_uart0, answer, 12);
        } break;
        case 0x13: {
            uint8_t answer[] = {0x13, 0x00, 0x00, 0x00, 0x00, 0x00, 0x17, 0xF0};

            device.CS_Pin = FLASH_CS1;
            device.spihandle = &g_mss_spi0;
            uint32_t result = TestMetaWriter(device);
            if (result == 0) {
                answer[5] = (1 << 0);
            }
            /*TODO: implement other tests here*/
            MSS_UART_polled_tx(&g_mss_uart0, answer, 8);
        }break;
        case 0xAA: {
            // empty the chip
            chipErase(device);
            device.CS_Pin = FLASH_CS2;
            chipErase(device);
            uint8_t txBuff[] = {0xAA, 0x00, 0x00, 0x00, 0x00, 0x0F, 0x17, 0xF0};
            MSS_UART_polled_tx(&g_mss_uart0, txBuff, 8);
            mssSignals |= MSS_MEMORY_ERASE;
            } break;

        default: {
            // no known command
            uint8_t txBuff[] = {rxBuff[0], 0, 0, 0, 0, 0xF0, 0x17, 0xF0};
            MSS_UART_polled_tx(&g_mss_uart0, txBuff, 8);
            }
        }

        // allow for another command processing
        rxIdx = 0;
        mssSignals &= ~MSS_SIGNAL_DAPI_CMD;
    }
}


#ifdef __cplusplus
}
#endif
