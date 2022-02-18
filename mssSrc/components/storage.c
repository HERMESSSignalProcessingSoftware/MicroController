/*
 * storage.c
 *
 *  Created on: 18.02.2022
 *      Author: RG
 */


#include <stdint.h>
#include "storage.h"
#include "../drivers/mss_spi/mss_spi.h"
#include "../status.h"

 void EraseMemory(void){
    SPI_Values device = { .CS_Pin = FLASH_CS1, .spihandle = &g_mss_spi0 };
    chipErase(device);
    device.CS_Pin = FLASH_CS2;
    chipErase(device);
    mssSignals |= MSS_MEMORY_ERASE;
}
