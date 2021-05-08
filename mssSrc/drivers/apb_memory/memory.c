/*
 * memory.c
 *
 *  Created on: 08.05.2021
 *      Author: Robin Grimsmann
 */

#include "memory.h"
#include "../../CMSIS/system_m2sxxx.h"
#include "../../hw_platform.h"

ConfigStatusT ResolveBitfield(uint32_t value) {
    ConfigStatusT csr = {0};
    csr.SPIStartAddr    = value & (~0xFFFFFFFE);
    csr.LockCUFSM       = value & (1 << CSR_MASK_LOCK_FSM);
    csr.PageSize        = (value >> 8) & (0x0000FFFF);
    return csr;
}


void SetStartAddress(uint32_t startAddr) {
    HW_set_32bit_reg(ADDR_MEMORY | MEMORY_STARTADDR, startAddr);
}

void ReadMemory(enumMEM mem, uint32_t *memPool, uint32_t page) {
    if (memPool) {
        uint32_t cmd        = page & 0x00FFFF00;
        addr_t addrReading  = ADDR_MEMORY | MEMORY_MEMORY_READBACK_REG;
        addr_t addrCmd      = ADDR_MEMORY | MEMORY_COMMAND_REG;
        addr_t addrCSR      = ADDR_MEMORY | MEMORY_CONFIG_STATUS_REG;
        uint32_t memPoolCnt = 0;
        uint32_t data       = 0;
        switch(mem) {
            case nCS1:
                cmd |= (COMMAND_READ_EXTERNAL_MEMORY_NCS1 << CMD_SHIFT);
                break;
            case nCS2:
                cmd |= (COMMAND_READ_EXTERNAL_MEMORY_NCS2 << CMD_SHIFT);
                break;
            default:
                break;
        }
        uint32_t CSR = HW_get_32bit_reg(addrCSR);
        ConfigStatusT c = ResolveBitfield(CSR);
        if (((CSR & MASK(CSR_MASK_SPI_BUSY)) | (CSR & MASK(CSR_MASK_MEMORY_LOADED))) == 0) {
            HW_set_32bit_reg(addrCmd, cmd);
            do {
                CSR  = HW_get_32bit_reg(addrCSR);
            } while(CSR & MASK(CSR_MASK_READING_INDICATOR)); // Wait until memory is loaded
            do {
                data = HW_get_32bit_reg(addrReading);
                CSR  = HW_get_32bit_reg(addrCSR);
                memPool[memPoolCnt++] = data;
            } while(CSR  & MASK(CSR_MASK_MEMORY_LOADED)); // While memory is available read
        }

    }
}

void ReadStamps(Stamp_t *stamp) {
    uint32_t *p = (uint32_t *)stamp;
    for (int i = 4; i < 0x034; i += 4) {
        *(p++) = HW_get_32bit_reg(ADDR_MEMORY | i);
        //p++;
    }
}


void InitMemory(ConfigStatusT csr) {
    uint32_t csr_value = CreateBitfield(csr);
    HW_set_32bit_reg(ADDR_MEMORY | MEMORY_CONFIG_STATUS_REG, csr_value);
    HW_set_32bit_reg(ADDR_MEMORY | MEMORY_STARTADDR, csr.StartPageNumber);
}
