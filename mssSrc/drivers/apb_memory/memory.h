/*
 * MemoryRev2.h
 *
 *  Created on: 18.06.2021
 *      Author: Robin Grimsmann
 */

#ifndef DRIVERS_APB_MEMORY_H_
#define DRIVERS_APB_MEMORY_H_

#ifdef __cplusplus
extern "C" {
#endif

#include "../../drivers/mss_gpio/mss_gpio.h"
#include "../../hal.h"
#include "../../sb_hw_platform.h"
#include "../../drivers/mss_spi/mss_spi.h"
#include "../../components/telemetry.h"
#include "MemorySyncAPB.h"
#include "../../components/HERMESS.h"

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

#define PAGE_COUNT 125000

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
#define AUTO_START_ON   0x1
#define AUTO_START_OFF  0x0
/**
 * Disables the state machine of the memory synchronizer (MS) component
 *
 * NOTE: the enable signal for the fsm will stay low until
 * EnableMemorySync() is called.
 *
 * Does the SPI init of the mss
 * Configures the  MS with default values, you may change them
 * @param Erase 0: do not erease all other: Erase the whole chip
 */
void InitMemorySynchronizer(uint32_t, uint32_t);

/**
 * @brief Searches the first 512 pages for the last address and inits
 * the system with a start address higher than the last address found. (Last found address + 250)
 *
 * Note: The System writes 250 pages / s
 * @return
 */
MemoryConfig Recovery(void);

/**
 * Starts the memory synchronizer
 */
void StartMemorySync(void);

/**
 * Disables the Memory synchronizer
 */
void StopMemorySync(void);

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
 * Copies the registers Stamp1Shadow1 - Stamp6Shadow2, SR, SR2, Timestamp to the internal memory
 * @param puffer pointer to a memory region of 512 byte
 * @param telFrame pointer to typedef struct for telemetry
 * @param SRlocals missing three bits covering SODS SOE and LO signals to save them to memory
 * @return uint32_t the value of SR1 for interrupt reason examination after copying the data
 */
uint32_t CopyDataFabricToMaster(uint8_t *puffer, Telemmetry_t *telFrame, uint32_t SRlocals);

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
void Write32Bit(uint32_t value, uint32_t address, SPI_Values device);
/**
 * FOR TESTING PURPOSE
 */
uint32_t testMemory(void);

/**
 *
 * @param pageAddr the address to be saved on page 0 - 0x199
 * @param metaAddress the page  address of the current meta page
 * @param dev the device to be safed on
 * @return uint32_t page address of the current page
 */
uint32_t UpdateMetadata(uint32_t pageAddr, uint32_t metaAddress, SPI_Values dev);



#ifdef __cplusplus
}
#endif

#endif /* DRIVERS_APB_MEMORY_MEMORYREV2_H_ */
