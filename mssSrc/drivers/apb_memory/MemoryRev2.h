/*
 * MemoryRev2.h
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

#define REGADDR(i) ( ADDR_MEMORY | i)

/*Warining: Chip Erease below!*/
#define c_CE 0xC7

/**
 * spihandle = hspin where n E {1,2,...,m}
 * CS_Pin = the Pin connected to n_chipselect of the corresponding flash memory
 * CS_Port = GPION N E {A,B,...,E}
 */
typedef struct {
    mss_spi_instance_t *spihandle;
    uint32_t CS_Pin;
} SPI_Values;

/**
 * Inits the memory
 *
 * \deprecated
 */
//int32_t InitMemory(void);

/**
 * Disables the state machine of the memory synchronizer (MS) component
 *
 * NOTE: the enable signal for the fsm will stay low until
 * EnableMemorySync() is called.
 *
 * Does the SPI init of the mss
 * Configures the  MS with default values, you may change them
 *
 */
void InitSPIMemory(void);

/**
 *
 */
uint32_t FastMemoryTest(void);

/*
 * Enables the FSM of the memory synchronizer
 *
 */
void __inline EnableMemorySync(void);

/*
 * Disables the FSM of the memory synchronizer
 */
void __inline DisableMemorySync(void);


/**
 * Function Read Status
 * reads the status byte from the memory unit
 * @param: SPI_val
 * @return 8 bit status register
 */
uint8_t readStatus(SPI_Values);

/**
 *
 */
uint32_t FastTest(SPI_Values);

/**
 *  Function Write Byte
 *  @brief Writes one byte so SPI
 *  @param uint8_t data: the one byte
 *  @param SPI_Val: the specifier of the SPI
 *  @return 0: Ok.
 */
int writeByte(uint8_t data, SPI_Values);

/**
 * Function Write Page
 * @brief Transmits command C_WREN (write enable) to the SPI
 * C_WRITEPAGE. Transfered address now, after that you have to transfer one page (256 byte) of data.
 *
 * Data overview
 *
 * Byte :   1       2           3-6     7 - 263     264
 * Data:   c_WREN  c_WRITEPAGE ADDR    DATA        c_WRDI
 *
 * @param uint8_t * data: Pointer to the data field
 * @param uint32_t address: the address on the memory chip
 * @param SPI_Values SPI_val
 * @return 0: ok
 */
int writePage(uint8_t *data, uint32_t address, SPI_Values);

/**
 * Function Read Page
 * @brief
 * Reads one page from the memory unit. The address determines which page is going to be read.
 *
 * Data overview:
 * To Memory IC:
 * Byte:    1       2 - 5
 * Data:    c_READ  Address
 *
 * From Memory IC:
 * Byte:    0 - 256
 * Data:    Data
 *
 * @param uint8_t  * data: Pointer to the data array
 * @param uint32_t address: Address of the momory unit to be read
 * @param SPI_Values SPI_val: the corresponding SPI values
 * @return 0: ok
 */
int readPage(uint8_t *data, uint32_t address, SPI_Values);

/**
 * Function Chip Erase
 * Erases the whole chip
 * @param SPI_Values SPI_val: the corresponding memory ic
 */
int chipErase(SPI_Values);

/**
 * Waits for the bit WIP (Write in Progress) bit to toggle
 * Reads SR1 register from memory
 */
void writeReady(SPI_Values);

/**
 * FOR TESTING PURPOSE
 */
uint32_t testMemory(void);


#ifdef __cplusplus
}
#endif

#endif /* DRIVERS_APB_MEMORY_MEMORYREV2_H_ */
