/**
 * @mainpage HERMESS storage component
 *
 * @section intro_sec Introduction
 * !!!
 *
 * @section use_sec Usage
 * !!!
 *
 * @section hw_sec Hardware requirements
 * !!!
 */

#ifndef STORGAGE_H
#define STORGAGE_H


#ifdef __cplusplus
extern "C" {
#endif

#include "../drivers/apb_memory/MemorySyncAPB.h"
#include "../hw_platform.h"
#include "../drivers/mss_spi/mss_spi.h"

/**
 * spihandle = hspin where n E {1,2,...,m}
 * CS_Pin = the Pin connected to n_chipselect of the corresponding flash memory
 * CS_Port = GPION N E {A,B,...,E}
 */
typedef struct {
    mss_spi_instance_t *spihandle;
    uint32_t CS_Pin;
} SPI_Values;

/*
 * Defines the Startpage and on which SPI flash the system has to start
 * Holds the current page
 * Holds the ChipSelect pin from hw_platform.h to start with this device (see first line)
 * Holds the ChipSelect uses at his moment
 */
typedef struct {
    uint32_t RecoverySuccess;
    uint32_t StartPage;
    uint32_t CurrentPage;
    uint32_t StartChipSelect;
    uint32_t CurrentChipSelect;
    uint32_t MetaAddress;
} MemoryConfig;


#define DO_NOT_ERASE    0x0
#define DO_ERASE        0x1


/**
 * Creating a pointer to save the data internally and than process SPI actions
 *
 * */
extern uint8_t MemoryPtr[PAGESIZE];

/**
 * The numer of used bytes in the memory area referred by MemoryPtr
 */
extern uint32_t MemoryPtrWatermark32Bit;

/**
 * 
 * Does the SPI init of the mss
 * Configures the  MS with default values, you may change them
 * @param Erase 0: do not erease all other: Erase the whole chip
 * */
void InitSPI(uint32_t erase);

/**
 * @brief Searches the first 512 pages for the last address and inits
 * the system with a start address higher than the last address found. (Last found address + 250)
 *
 * Note: The System writes 250 pages / s
 * @return
 */
MemoryConfig Recovery(void);

/**
 *
 */
uint32_t FastMemoryTest(void);

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
 * @brief Reads a given number of bytes form memory
 *
 * @param data The memory region to save the read value at
 * @param address The memory start address to read from
 * @param count The number of bytes to be read
 * @param spi_val The device descriptor to be read from
 * @return 0: 0k, 1: Error
 */
int readBytes(uint8_t *data, uint32_t address, int count, SPI_Values spi_val);

/**
 * Writes a given number of bytes to the spi device; you may use this for partial page writing
 * @param data : The content for the memory
 * @param size : The number of bytes to be transfered
 * @param address : The address of the page which have to be written
 * @param device : The device which will receive the data
 */
void WriteBytes(uint8_t *data, uint32_t size, uint32_t address, SPI_Values device);

/**
 * @brief transmits a signal 32 bit value to the device by using partial page programming (Still 0x12 with less data)
 *
 * @param value : The Value to be transmitted
 * @param address : The address to be safed at
 * @param device : The memory device
 */

#ifdef __cplusplus
}
#endif


#endif
