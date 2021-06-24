///*
// * memory.c
// *
// *  Created on: 08.05.2021
// *      Author: Robin Grimsmann
// */
//
//#include "memory.h"
//#include "../../CMSIS/system_m2sxxx.h"
//#include "../../hw_platform.h"
//
//ConfigStatusT ResolveBitfield(uint32_t value) {
//    ConfigStatusT csr = { 0 };
//    csr.SPIStartAddr = value & (~0xFFFFFFFE);
//    csr.LockCUFSM = value & (1 << CSR_MASK_LOCK_FSM);
//    csr.PageSize = (value >> 8) & (0x0000FFFF);
//    return csr;
//}
//
//void SetStartAddress(uint32_t startAddr) {
//    HW_set_32bit_reg(ADDR_MEMORY | MEMORY_STARTADDR, startAddr);
//}
//
//void ReadMemory(enumMEM mem, uint32_t *memPool, uint32_t page) {
//    if (memPool) {
//        uint32_t cmd = page & 0x00FFFF00;
//        addr_t addrReading = ADDR_MEMORY | MEMORY_MEMORY_READBACK_REG;
//        addr_t addrCmd = ADDR_MEMORY | MEMORY_COMMAND_REG;
//        addr_t addrCSR = ADDR_MEMORY | MEMORY_CONFIG_STATUS_REG;
//        uint32_t memPoolCnt = 0;
//        uint32_t data = 0;
//        switch (mem) {
//        case nCS1:
//            cmd |= (COMMAND_READ_EXTERNAL_MEMORY_NCS1 << CMD_SHIFT);
//            break;
//        case nCS2:
//            cmd |= (COMMAND_READ_EXTERNAL_MEMORY_NCS2 << CMD_SHIFT);
//            break;
//        default:
//            break;
//        }
//        uint32_t CSR = HW_get_32bit_reg(addrCSR);
//        ConfigStatusT c = ResolveBitfield(CSR);
//        if (((CSR & MASK(CSR_MASK_SPI_BUSY))
//                | (CSR & MASK(CSR_MASK_MEMORY_LOADED))) == 0) {
//            HW_set_32bit_reg(addrCmd, cmd);
//            do {
//                CSR = HW_get_32bit_reg(addrCSR);
//            } while (CSR & MASK(CSR_MASK_READING_INDICATOR)); // Wait until memory is loaded
//            do {
//                data = HW_get_32bit_reg(addrReading);
//                CSR = HW_get_32bit_reg(addrCSR);
//                memPool[memPoolCnt++] = data;
//            } while (CSR & MASK(CSR_MASK_MEMORY_LOADED)); // While memory is available read
//        }
//
//    }
//}
//
//void ReadStamps(Stamp_t *stamp) {
//    uint32_t *p = (uint32_t*) stamp;
//    for (int i = 4; i < 0x034; i += 4) {
//        *(p++) = HW_get_32bit_reg(ADDR_MEMORY | i);
//        //p++;
//    }
//}
//
//void InitMemory(ConfigStatusT csr) {
//    uint32_t csr_value = CreateBitfield(csr);
//    HW_set_32bit_reg(ADDR_MEMORY | MEMORY_CONFIG_STATUS_REG, csr_value);
//    HW_set_32bit_reg(ADDR_MEMORY | MEMORY_STARTADDR, csr.StartPageNumber);
//}
//
///* not tested yet */
//void ReconfigureConfigStatusReg(uint32_t value) {
//    uint32_t CSRread = HW_get_32bit_reg(ADDR_MEMORY | MEMORY_CONFIG_STATUS_REG);
//    uint32_t CSRnew = CSRread & 0xE000001A;
//    /* Writing the new Pagesize */
//    CSRnew |= (value & 0x00FFFF00);
//    CSRnew |= (value & (1 << CSR_MASK_LOCK_FSM));
//    CSRnew |= (value & 0x00000001);
//    HW_set_32bit_reg(ADDR_MEMORY | MEMORY_CONFIG_STATUS_REG, CSRnew);
//}
//
//int TransmitData(uint32_t *data, size_t size, enumMEM memoryID) {
//    uint32_t rxReg = 0;
//    uint32_t counter = 0;
//    uint32_t csr = HW_get_32bit_reg(ADDR_MEMORY | MEMORY_CONFIG_STATUS_REG);
//    if (data && size > 0) {
//        for (size_t index = 0; index < size; index++) {
//            SPITransmit(data[index], memoryID, WAIT_UNTIL_DONE);
////            if (data[index] == 0x06000000 || data[index] == 0x00000006) { /* Check if write enable latch has be updated */
////                SPITransmit(0x05000000, memoryID, WAIT_UNTIL_DONE); /* Transmit command RDSR1 to the memory device */
////                SPITransmit(0x00, memoryID, WAIT_UNTIL_DONE); /* Receive the value of SR1 */
////                rxReg = HW_get_32bit_reg(ADDR_MEMORY | MEMORY_SPI_RX_REG);
////                if (rxReg & (1 << 1)) {
////                   /* WEL set */
////                   counter = 1;
////                }
////                SPITransmit(0x00, memoryID, WAIT_UNTIL_DONE); /* Receive the value of SR1 */
////                rxReg = HW_get_32bit_reg(ADDR_MEMORY | MEMORY_SPI_RX_REG);
////               if (rxReg & (1 << 1)) {
////                  /* WEL set */
////                  counter = 1;
////               }
////            }
//        }
//    }
//    return counter;
//}
//
//void SPITransmit(uint32_t data, enumMEM dest, SPIWaitingMode waiting) {
//    uint32_t csr = 0;
//    uint32_t command;
//    switch(dest) {
//    case nCS1:
//        command = COMMAND_SPI_TRANSMIT_NCS1 << CMD_SHIFT;
//        break;
//    case nCS2:
//        command = COMMAND_SPI_TRANSMIT_NCS2 << CMD_SHIFT;
//        break;
//    default:
//        break;
//    }
//
//    /* Wait until SPI is cleared */
//    do {
//        csr = HW_get_32bit_reg(ADDR_MEMORY | MEMORY_CONFIG_STATUS_REG);
//    } while(csr & MASK(CSR_MASK_SPI_BUSY));
//    /* Load new data into SPI TX reg */
//    HW_set_32bit_reg(ADDR_MEMORY | MEMORY_SPI_TX_REG, data);
//    /* Transmit the data to the device */
//    HW_set_32bit_reg(ADDR_MEMORY | MEMORY_COMMAND_REG, command);
//    /* wait here until spi finished the transmission */
//    if (waiting == WAIT_UNTIL_DONE) {
//        do {
//            csr = HW_get_32bit_reg(ADDR_MEMORY | MEMORY_CONFIG_STATUS_REG);
//        } while (csr & MASK(CSR_MASK_SPI_BUSY));
//    }
//}
//
