/*
 * memory.h
 *
 *  Created on: 18.06.2021
 *      Author: Robin Grimsmann
 */

#ifndef DRIVERS_APB_MEMORY_MEMORYREV2_H_
#define DRIVERS_APB_MEMORY_MEMORYREV2_H_

#ifdef __cplusplus
extern "C" {
#endif

//#include "memory.h"
//#include "../../CMSIS/system_m2sxxx.h"
#include "../../drivers/mss_gpio/mss_gpio.h"
#include "../../hal.h"
#include "../../hw_platform.h"
#include "../../drivers/mss_spi/mss_spi.h"
#include "../../components/tools.h"
#include "MemorySyncAPB.h"

#define c_WRDI 0x04
#define c_READSTATUSREG1 0x05
#define c_READSTATUSREG2 0x07
#define c_READCONFIGREG1 0x35
#define c_CLEARSTATUSREG1 0x30
#define c_WREN 0x06
#define c_READSTATUSREG2 0x07
#define c_WRITEPAGE 0x12
#define c_READ 0x13
#define c_READID 0x9F
/*Warining: Chip Erease below!*/
#define c_CE 0xC7

#define AUTO_START_ON   0x1
#define AUTO_START_OFF  0x0

#define PAGESIZE 512
/*
 * Calculates the ADDRESS of the Register by BASEADDR | REGADDR
 * */
#define MEMORY_REG(i) ( ADDR_MEMORY | i)

/*
 * The maxium datasets per page
 */
#define DATASETS_PER_PAGE = 8

/**
 * Creating a pointer to save the data internally and than process SPI actions
 *
 * */
extern uint8_t MemoryPtr[PAGESIZE];

#define METADATA_PAGEADDR   0x0
extern uint8_t MemoryMetadataPage[PAGESIZE];

/**
 * The numer of used bytes in the memory area referred by MemoryPtr
 */
extern uint32_t MemoryPtrWatermark32Bit;

/*
 * The number of interrupts is an indicator for the frame, transmitted by telemetry
 */
extern uint32_t MemoryInterruptCounter;

/*
 * Continuous counts the datasets of the SPU starting with 0 on STARTPAGE at nCSx with x defined by the user
 */
extern uint32_t MemoryDatasetCounter;

/**
 * Disables the state machine of the memory synchronizer (MS) component
 *
 * NOTE: the enable signal for the fsm will stay low until
 * EnableMemorySync() is called.
 *
 * Does the SPI init of the mss
 * Configures the  MS with default values, you may change them
 * @param start 1 (AUTO_START_ON): start the hdl component
 */
void InitMemorySynchronizer(uint32_t);

/*
 * Copies the registers Stamp1Shadow1 - Stamp6Shadow2, SR, SR2, Timestamp to the internal memory
 * @param puffer pointer to a memory region of 512 byte
 * @param SRlocals missing three bits covering SODS SOE and LO signals to save them to memory
 * @return uint32_t the value of SR1 for interrupt reason examination after copying the data
 */
uint32_t CopyDataFabricToMaster(uint8_t *puffer, uint32_t SRlocals);


void Write32Bit(uint32_t value, uint32_t address, SPI_Values device);

/**
 * FOR TESTING PURPOSE
 */
uint32_t TestDRIVER(void);




#ifdef __cplusplus
}
#endif

#endif /* DRIVERS_APB_MEMORY_MEMORY_H_ */
