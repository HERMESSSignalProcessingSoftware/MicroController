/*
 * memory.c
 *
 *  Created on: Jun 17, 2021
 *      Author: Robin Grimsmann
 */

#include "memory.h"
#include <stdio.h>
#include "../../drivers/mss_gpio/mss_gpio.h"
#include "../../hw_platform.h"

#define PAGE_COUNT 125000

/**
 * Creating a pointer to save the data internally and than process SPI actions
 *
 * */
uint8_t MemoryPtr[PAGESIZE];

/**
 * The numer of used bytes in the memory area referred by MemoryPtr
 */
uint32_t MemoryPtrWatermark32Bit = 0x0;

/*
 * The number of interrupts is an indicator for the frame, transmitted by telemetry
 */
uint32_t MemoryInterruptCounter = 0x0;

/*
 * Continuous counts the datasets of the SPU starting with 0 on STARTPAGE at nCSx with x defined by the user
 */
uint32_t MemoryDatasetCounter = 0x0;

/*
 * The fist page of nCS1 connected device contains the current Page address on
 */
uint8_t MemoryMetadataPage[PAGESIZE];

void InitMemorySynchronizer(uint32_t start) {
    MSS_SIGNALS = 0x0;
    /* Set disable the not ABP part of this component*/
    MSS_GPIO_set_output(OUT_ENABLE_MEM_SYNC, 0);

  
    /* Disable Interrupts */
    NVIC_DisableIRQ(MEMORY_SYNC_IRQn);
    NVIC_ClearPendingIRQ(MEMORY_SYNC_IRQn);

    /* Init via APB */
    uint32_t ConfigRegValue = CONFIG_REG_ENABLE_INTERRUPT;
    ConfigRegValue |= CONFIG_REG_NUMBER_OF_NEW_AVAILABLES(4);
    ConfigRegValue |= CONFIG_REG_NUMBER_OF_REQUEST_RESNYCS(4);
    HW_set_32bit_reg(MEMORY_REG(ConfigReg), ConfigRegValue);
    /* Programm the Waiting Value of S1 to 500 (20us)*/
    HW_set_32bit_reg(MEMORY_REG(WaitingTimerValueReg), 0x000001F4);
    /* Wait for 2 ms after each Resync Event */
    HW_set_32bit_reg(MEMORY_REG(ResyncTimerValueReg), 0x0000C350);
    /* Set the Reset Timer to 500 ms*/
    HW_set_32bit_reg(MEMORY_REG(ResyncTimerValueReg), 0x00bebc20);

    /* Setup the puffer */
    for (int i = 0; i < PAGESIZE; i++) {
        MemoryPtr[i] = 0;
    }
    
    NVIC_EnableIRQ(MEMORY_SYNC_IRQn);
    if(start == AUTO_START_ON) {
        /* Enable this component */
        MSS_GPIO_set_output(OUT_ENABLE_MEM_SYNC, 1);
    } else {
        MSS_GPIO_set_output(OUT_ENABLE_MEM_SYNC, 0);
    }
}

/*
 * Copies the registers Stamp1Shadow1 - Stamp6Shadow2, SR, SR2, Timestamp to the internal memory
 * @param puffer pointer to a memory region of 512 byte
 * @param SRlocals missing three bits covering SODS SOE and LO signals to save them to memory
 * @return uint32_t the value of SR1 for interrupt reason examination after copying the data
 */
uint32_t CopyDataFabricToMaster(uint8_t *puffer, uint32_t SRlocals) {
    uint32_t SR1 = HW_get_32bit_reg(MEMORY_REG(SynchStatusReg));
    SR1 |= SRlocals;
    if (puffer) {
        uint32_t *ptr32 = (uint32_t*) puffer;
        if (MemoryPtrWatermark32Bit == 0) {
            puffer[0] = 0x7F; // Basic start of page magic number
            puffer[1] = (uint8_t) ((MemoryDatasetCounter >> 16) & 0x000000FF);
            puffer[2] = (uint8_t) ((MemoryDatasetCounter >> 8) & 0x000000FF);
            puffer[3] = (uint8_t) ((MemoryDatasetCounter) & 0x000000FF);
            MemoryPtrWatermark32Bit++;
            MemoryDatasetCounter++;
        }
        ptr32[MemoryPtrWatermark32Bit++] = HW_get_32bit_reg(
                MEMORY_REG(TimeStampReg));
        /*Copy all the data */
        for (int i = LOWESTSTAMP; i <= HIGHESTSTAMP; i += 4) {
            ptr32[MemoryPtrWatermark32Bit++] = HW_get_32bit_reg(MEMORY_REG(i));
            HW_set_32bit_reg(MEMORY_REG(i), 0x0); //Reset the stamp shadow registers
        }
        /* Add status registers */
        ptr32[MemoryPtrWatermark32Bit++] = SR1;
        ptr32[MemoryPtrWatermark32Bit++] = HW_get_32bit_reg(
                MEMORY_REG(SynchStatusReg2));
        /* Reset TimeStampReg, SR2, SR1 values */
        HW_set_32bit_reg(MEMORY_REG(TimeStampReg), 0x0);
        HW_set_32bit_reg(MEMORY_REG(SynchStatusReg2), 0x0);
        HW_set_32bit_reg(MEMORY_REG(SynchStatusReg), 0x0);
    }
    return SR1;
}


