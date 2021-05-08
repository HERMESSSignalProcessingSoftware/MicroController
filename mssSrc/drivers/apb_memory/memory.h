/*
 * memory.h
 *
 *  Created on: 06.05.2021
 *      Author: Robin Grimsmann
 */

#ifndef DRIVERS_APB_MEMORY_MEMORY_H_
#define DRIVERS_APB_MEMORY_MEMORY_H_

#include <stdint.h>
#include "../../hal/hal.h"

#ifdef __cplusplus
extern "C" {
#endif

/**
 * Addresses of the memory component
 */
#define MEMORY_STAMP1_REG1          0x004
#define MEMORY_STAMP1_REG2          0x008

#define MEMORY_STAMP2_REG1          0x00C
#define MEMORY_STAMP2_REG2          0x010

#define MEMORY_STAMP3_REG1          0x014
#define MEMORY_STAMP3_REG2          0x018

#define MEMORY_STAMP4_REG1          0x01C
#define MEMORY_STAMP4_REG2          0x020

#define MEMORY_STAMP5_REG1          0x024
#define MEMORY_STAMP5_REG2          0x028

#define MEMORY_STAMP6_REG1          0x02C
#define MEMORY_STAMP6_REG2          0x030

#define MEMORY_STARTADDR            0x034
#define MEMORY_CURRENTADDR          0x038
#define MEMORY_SPI_TX_REG           0x03C
#define MEMORY_SPI_RX_REG           0x040
#define MEMORY_CONFIG_STATUS_REG    0x044
#define MEMORY_COMMAND_REG          0x048
#define MEMORY_MEMORY_READBACK_REG  0x04C



#define DEFAULT_PAGESIZE            0x200

/*
 * CSR_MASK_SPI_START describes the value of the SPIAddr value in the fabric
 * DO NOT CHANGE IT DURING FLIGHT
 * 0: ADDR will be 0 (nCS1 active first)
 * 1: ADDR will be 1 (nCS2 active first)
 * */
#define CSR_MASK_SPI_START              0

/**
 * CSR_MASK_SPI_CURRENT_ADDR describes the bit position of the current
 * spi addr indicator in the ConfigStatusReg
 * 0: Will be writing to SPI addr 0 (nCS1 active)
 * 1: Will be writing to SPI addr 1 (nCS2 active)
 */
#define CSR_MASK_SPI_CURRENT_ADDR       1

/**
 * CSR_MASK_LOCK_FSM Bit Position of the Lock bit in ConfigStatusReg
 * Bit value:
 * 1: Will lock the CU FSM, no stamp data will be proceeded
 * 0: Release the lock of the FSM
 * Note: This bit will be toggled by the fabric during APB3 SPI Read
 */
#define CSR_MASK_LOCK_FSM               2

/**
 * CSR_MASK_READING_INDICATOR bit position
 * Bit value:
 * 0: Done
 * 1: in progress
 */
#define CSR_MASK_READING_INDICATOR      3

/**
 * CSR_MASK_MEMORY_LOADED bit position in the ConfigStatusReg
 * Bit value:
 * 0: Memory not loaded or APB3 Reading (0x04C) reached its ent
 * 1: Memory loaded, ready to use
 */
#define CSR_MASK_MEMORY_LOADED          4

/**
 * CSR_MASK_MEMORY_PAGESIZE bit position, starting by value
 */
#define CSR_MASK_MEMORY_PAGESIZE        8


#define CSR_MASK_SPI_BUSY               29
/**
 * CSR_MASK_CU_WAITING_INDICATOR bit position
 * Bit value:
 * 0: CU FSM busy
 * 1: Waiting
 */
#define CSR_MASK_CU_WAITING_INDICATOR   30

/**
 * CSR_MASK_SPI_ADDR_SAVED bit position
 * used by the state machine to save the current spi addr in case APB3 is using the SPI module
 * Bit Value:
 * 0: SPI addr 0, nCS1 active
 * 1: SPI addr 1, nCS2 active
 */
#define CSR_MASK_SPI_ADDR_SAVED         31

/**
 * creates a bitmask for the positions
 */
#define MASK(t) (1 << t)

typedef struct CSR {
    uint8_t     SPIStartAddr;
    uint8_t     LockCUFSM;
    uint16_t    PageSize;
    uint32_t    StartPageNumber;
    uint32_t    CurrentPageNumber;
} ConfigStatusT;

#define CreateBitfield(CSR)((uint32_t)CSR.PageSize       << CSR_MASK_MEMORY_PAGESIZE | \
                            (uint32_t)CSR.LockCUFSM      << CSR_MASK_LOCK_FSM | \
                            (uint32_t)CSR.SPIStartAddr   << CSR_MASK_SPI_START)

/**
 * Creates the struct out of the register value
 * @param value : the value read form the ConfigStatusReg
 * @return typedef struct ConfigStatusT
 */
ConfigStatusT ResolveBitfield(uint32_t value);

#define CSR_START_WITH_NCS1             0
#define CSR_START_WITH_NCS2             1
#define CSR_LOCK_CU_FSM                 1
#define CSR_UNLOCK_CU_FSM               0
#define CSR_DEFAULT_PAGESIZE            0x200

/**
 * Reads the page with address defined in the last three byte and saves it to internal RAM
 *
 * COMMAND definition: <CMD><ADDR><ADDR><ADDR> // 4 bytes
 * Active SPI line: nCS1 connected device
 * If finished: CSR(4) will be set to 1
 * You need to read 0x04C to copy the content to M3 controller
 */
#define COMMAND_READ_EXTERNAL_MEMORY_NCS1   0x01

/**
 * Reads the page with address defined in the last three byte and saves it to internal RAM
 *
 * COMMAND definition: <CMD><ADDR><ADDR><ADDR> // 4 bytes
 * Active SPI line: nCS2 connected device
 * If finished: CSR(4) will be set to 1
 * You need to read 0x04C to copy the content to M3 controller
 */
#define COMMAND_READ_EXTERNAL_MEMORY_NCS2   0x11

/**
 * Triggers a SPI transmit action
 *
 * COMMAND definition: <CMD><XXX><XXX><XXX>
 * With X: do not care
 *
 * Active SPI line: nCS1
 */
#define COMMAND_SPI_TRANSMIT_NCS1           0x02

/**
 * Triggers a SPI transmit action
 *
 * COMMAND definition: <CMD><XXX><XXX><XXX>
 * With X: do not care
 *
 * Active SPI line: nCS2
 */
#define COMMAND_SPI_TRANSMIT_NCS2           0x12

/**
 * Resets the Memory internal FSM for SPI usage:
 * When ABP writes to 0x03C (SPI_TX_Reg) the FSM will enter state READY
 * But it does not transfer anything until a CMD (0x02 | 0x12) is given.
 * Enables the SPI again to transmit the same value again
 */
#define COMMAND_RELOAD_SPI_TX_REG           0x03

#define CMD_SHIFT                           24

/**
 *
 */
typedef enum {nCS1, nCS2} enumMEM;

typedef struct {
    uint32_t Stamp11;
    uint32_t Stamp12;
    uint32_t Stamp21;
    uint32_t Stamp22;
    uint32_t Stamp31;
    uint32_t Stamp32;
    uint32_t Stamp41;
    uint32_t Stamp42;
    uint32_t Stamp51;
    uint32_t Stamp52;
    uint32_t Stamp61;
    uint32_t Stamp62;
} Stamp_t;

/**
 *
 * @param mem either nCS1 or nCS2, its your choise its spezifiy the memory which has to be read
 * @param memPool an array of at least 128 elements to save the values form Memory component
 * @param page the page to be read
 */
void ReadMemory(enumMEM mem, uint32_t *memPool, uint32_t page);

/**
 *
 * @param startAddr the page to be started with
 */
void SetStartAddress(uint32_t startAddr);

/**
 * Initialize the memory component by writing the content of the typedef struct ConfigStatusT to the component
 * @param csr the struct to be written
 */
void InitMemory(ConfigStatusT csr);
/**
 * Reads the shadow regs of the Memory component saves the value of the stamps to a local copy.
 * May use this for telemetry
 * @param stamp
 */
void ReadStamps(Stamp_t *stamp);
#ifdef __cplusplus
}
#endif
#endif /* DRIVERS_APB_MEMORY_MEMORY_H_ */
