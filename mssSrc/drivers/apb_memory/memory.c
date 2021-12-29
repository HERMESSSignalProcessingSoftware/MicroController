/*
 * Memory.c
 *
 *  Created on: Jun 17, 2021
 *      Author: Robin Grimsmann
 */

#include "memory.h"
#include "MemorySyncAPB.h"
#include <stdio.h>
#include "../../drivers/mss_gpio/mss_gpio.h"
#include "../../sb_hw_platform.h"
#include "../../drivers/mss_spi/mss_spi.h"
#include "../../components/telemetry.h"
#include "../../components/HERMESS.h"
#include "../../components/tools.h"

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
 * The fist page of FLASH_CS1 connected device contains the current Page address on
 */
uint8_t MemoryMetadataPage[PAGESIZE];

void InitMemorySynchronizer(uint32_t Erase, uint32_t start) {
    /* Set disable the not ABP part of this component
     *
     * Make sure the component does not trigger any interrupts during this procedure
     * */
    MSS_GPIO_set_output(OUT_ENABLE_MEM_SYNC, 0);

    /* Do the SPI init */
    MSS_SPI_init(&g_mss_spi0);
    MSS_SPI_configure_master_mode(&g_mss_spi0, MSS_SPI_SLAVE_0, MSS_SPI_MODE0,
            16u, MSS_SPI_BLOCK_TRANSFER_FRAME_SIZE);
    /* Do set the nCSx signals to high */
    MSS_GPIO_set_output(FLASH_CS1, 1);
    MSS_GPIO_set_output(FLASH_CS2, 1);
    MSS_SPI_set_slave_select(&g_mss_spi0, MSS_SPI_SLAVE_0);

    /* Disable Interrupts */
    NVIC_DisableIRQ(MEMORY_SYNC_IRQn);
    NVIC_ClearPendingIRQ(MEMORY_SYNC_IRQn);
//    uint32_t RegVal = 0;
//    HW_set_32bit_reg(ADDR_MEMORY | Stamp1ShadowReg1, 0x11);
//    RegVal = HW_get_32bit_reg(ADDR_MEMORY | Stamp1ShadowReg1);
//    for (int i = LOWSTADDR; i < HIGHSTADDR + 1; i += 4) {
//        RegVal = HW_get_32bit_reg(MEMORY_REG(i));
//    }
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

    /* Setup the memory */

    for (int i = 0; i < PAGESIZE; i++) {
        MemoryPtr[i] = 0;
    }

    /*DO this once */
    if (Erase == DO_ERASE) {
        SPI_Values cErease;
        cErease.spihandle = &g_mss_spi0;
        cErease.CS_Pin = FLASH_CS1;
        chipErase(cErease);
        cErease.CS_Pin = FLASH_CS2;
        chipErase(cErease);
    }
    NVIC_EnableIRQ(MEMORY_SYNC_IRQn);
    if(start == AUTO_START_ON) {
        /* Enable this component */
        MSS_GPIO_set_output(OUT_ENABLE_MEM_SYNC, 1);
    }
}

void StartMemorySync(void) {
    MSS_GPIO_set_output(OUT_ENABLE_MEM_SYNC, 1);
}

void StopMemorySync(void) {
    MSS_GPIO_set_output(OUT_ENABLE_MEM_SYNC, 0);
}

MemoryConfig Recovery(void) {
    MemoryConfig mC = {0};
    mC.RecoverySuccess = 0;
    uint8_t buffer[512] = {0};
    SPI_Values dev;
    dev.spihandle = &g_mss_spi0;
    dev.CS_Pin = FLASH_CS1;
    uint32_t *ptr = (uint32_t*)buffer;
    uint32_t nextOneHits = 0;
    uint32_t pageCounter = 0;
    for (int i = 0; i < START_OF_DATA_SEGMENT; i++) {
        readPage(buffer, i, dev);
        /* Look at every 4 bytes*/
        for (int j = 0; j < 128; j++) {
            if (ptr[j] == 0xFFFFFFFF) { /* the value before is the last, saved page address*/
                 pageCounter = i;
                 nextOneHits = j - 1;
                 break;
            }
        }
        if (nextOneHits != 0) {
            uint32_t value = ptr[nextOneHits];
            if (value < START_OF_DATA_SEGMENT) {
                mC.RecoverySuccess = 0;
            } else {
                mC.RecoverySuccess = 1;
            }
            mC.CurrentPage = value;
            mC.StartPage = value;
            mC.MetaAddress = pageCounter;
            break;
        }
    }

    return mC;
}

/**
 * Performes a fast memory test, just writes one page and reads it
 *
 */
uint32_t FastMemoryTest(void) {

    char writeBuffer[256] = "Starting FLASH Test...\r\n";
    spuLog(writeBuffer);

    SPI_Values DUT0;
    DUT0.CS_Pin = FLASH_CS1;
    DUT0.spihandle = &g_mss_spi0;
    //
    SPI_Values DUT1;
    DUT1.CS_Pin = FLASH_CS2;
    DUT1.spihandle = &g_mss_spi0;

//

    uint32_t result = 0;
    uint32_t startTime = 0;
    uint32_t endTime = 0;
    uint32_t kbits = 0;

    sprintf(writeBuffer, "\t%s\n\r\0", "Checking FL1/1");
    spuLog(writeBuffer);
    result = FastTest(DUT0);
    sprintf(writeBuffer, "\t\tResult: %s\r\n\0",
            result == 1 ? "Passed" : "Failed");
    spuLog(writeBuffer);
    delay(50);

    sprintf(writeBuffer, "\t%s\n\r\0", "Checking FL1/2");
    spuLog(writeBuffer);
    result = FastTest(DUT1);
    sprintf(writeBuffer, "\t\tResult: %s\r\n\0",
            result == 1 ? "Passed" : "Failed");
    spuLog(writeBuffer);
    delay(50);

    return 0;
}

uint32_t FastTest(SPI_Values spi_val) {
    uint8_t writeBuffer[PAGESIZE] = { 0 };
    uint8_t readBuffer[PAGESIZE] = { 0 };
    uint32_t adresse = 1;
    volatile uint8_t SR1;
    //Testdaten initialisieren
    for (int i = 0; i < PAGESIZE; i++) {
        writeBuffer[i] = i;
    }

    writePage(writeBuffer, adresse, spi_val);
    //Warten bis fertig geschrieben wurde
    writeReady(spi_val);
    //Selbe page auslesen
    readPage(readBuffer, adresse, spi_val);
    //Inhalt vergleichen
    for (int y = 0; y < PAGESIZE; y++) {
        //Wenn inhalt nicht gleich
        if (writeBuffer[y] != readBuffer[y]) {
            SR1 = readStatus(spi_val);
            return 0;
        }
    }
    writeReady(spi_val);
    return 1;
}

/**
 * Function Read Status
 * reads the status byte from the memory unit
 * @param: SPI_val
 * @return 8 bit status register
 */
uint8_t readStatus(SPI_Values spi_val) {
    uint8_t data;
    uint8_t command = c_READSTATUSREG1;
    //CS low
    MSS_GPIO_set_output(spi_val.CS_Pin, 0);

    //delay(1);

    //send command and read answer into data
    MSS_SPI_transfer_frame(&g_mss_spi0, command);
    data = MSS_SPI_transfer_frame(&g_mss_spi0, 0x00);

    //CS high
    MSS_GPIO_set_output(spi_val.CS_Pin, 1);
    return data;
}

/**
 *  Function Write Byte
 *  @brief Writes one byte so SPI
 *  @param uint8_t data: the one byte
 *  @param SPI_Val: the specifier of the SPI
 *  @return 0: Ok.
 */
int writeByte(uint8_t data, SPI_Values spi_val) {
    MSS_GPIO_set_output(spi_val.CS_Pin, 0);
    //delay(1);

    //send command and read answer into data
    MSS_SPI_transfer_frame(&g_mss_spi0, data);

    //CS1 high
    MSS_GPIO_set_output(spi_val.CS_Pin, 1);
    return 0;
}

/**
 * Function Write Page
 * @brief Transmits command C_WREN (write enable) to the SPI
 * C_WRITEPAGE. Transfert address now, after that you have to transfer one page (256 byte) of data.
 *
 * Data overview
 *
 * Byte :   1       2           3-6     7 - 263     264
 * Ddata:   c_WREN  c_WRITEPAGE ADDR    DATA        c_WRDI
 *
 * @param uint8_t * data: Pointer to the data field
 * @param uint32_t address: the address on the memory chip
 * @param SPI_Values SPI_val
 * @return 0: ok
 */
int writePage(uint8_t *data, uint32_t address, SPI_Values spi_val) {
    uint8_t recBuffer[PAGESIZE] = { 0 };
    uint8_t command = c_WRITEPAGE;
    uint8_t tmp_add;

//Write enable
    writeByte(c_WREN, spi_val);

    MSS_GPIO_set_output(spi_val.CS_Pin, 0);
    //commando schicken
    MSS_SPI_transfer_frame(&g_mss_spi0, command);
    //delay(1); /* !!! Do not use this in productiv application, build a function which is able to wait just a few us*/

    /* end of waiting */
    //Addressse schicken MSB to LSB
    //address = 0x11223344;
    //MSS_SPI_transfer_block(&g_mss_spi0, &address, 4, recBuffer, 0); /* Reihnfolge der bytes ist nicht richtig */
    tmp_add = (uint8_t) ((address >> 24) & 0x000000FF);
    MSS_SPI_transfer_frame(&g_mss_spi0, tmp_add);

    tmp_add = (uint8_t) ((address >> 16) & 0x000000FF);
    MSS_SPI_transfer_frame(&g_mss_spi0, tmp_add);

    tmp_add = (uint8_t) ((address >> 8) & 0x000000FF);
    MSS_SPI_transfer_frame(&g_mss_spi0, tmp_add);

    tmp_add = (uint8_t) (address & 0x000000FF);
    MSS_SPI_transfer_frame(&g_mss_spi0, tmp_add);
    //Daten schicken
    for (int i = 0; i < PAGESIZE; i++) {
        MSS_SPI_transfer_frame(&g_mss_spi0, data[i]);

    }

    MSS_GPIO_set_output(spi_val.CS_Pin, 1);

    //Write disable
    writeByte(c_WRDI, spi_val);
    return 0;
}

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
 * Byte:    0 - 512
 * Data:    Data
 *
 * @param uint8_t  * data: Pointer to the data array
 * @param uint32_t address: Address of the momory unit to be read
 * @param SPI_Values SPI_val: the corresponding SPI values
 * @return 0: ok
 */
int readPage(uint8_t *data, uint32_t address, SPI_Values spi_val) {

    uint8_t command = c_READ;
    uint8_t tmp_add;
    //CS low
    MSS_GPIO_set_output(spi_val.CS_Pin, 0);

    //commando schicken
//  writeByte(c_READ, SPI_val);
    MSS_SPI_transfer_frame(&g_mss_spi0, command);

//4 Byte Addressse schicken MSB to LSB
//  HAL_SPI_Transmit(SPI_val.spihandle, (uint8_t*) (&address), 4, 40);
    tmp_add = (uint8_t) ((address >> 24) & 0x000000FF);
    MSS_SPI_transfer_frame(&g_mss_spi0, tmp_add);

    tmp_add = (uint8_t) ((address >> 16) & 0x000000FF);
    MSS_SPI_transfer_frame(&g_mss_spi0, tmp_add);

    tmp_add = (uint8_t) ((address >> 8) & 0x000000FF);
    MSS_SPI_transfer_frame(&g_mss_spi0, tmp_add);

    tmp_add = (uint8_t) (address & 0x000000FF);
    MSS_SPI_transfer_frame(&g_mss_spi0, tmp_add);

//Daten lesen+
    for (int i = 0; i < PAGESIZE; i++) {
        data[i] = MSS_SPI_transfer_frame(&g_mss_spi0,  0x00);
    }

//CS high
    MSS_GPIO_set_output(spi_val.CS_Pin, 1);

    return 0;
}

/**
 * Function Chip Erase
 * Erases the whole chip
 * @param SPI_Values SPI_val: the corresponding memory ic
 */
int chipErase(SPI_Values SPI_val) {
    //Write enable
    writeByte(c_WREN, SPI_val);
    //erase chip
    writeByte(c_CE, SPI_val);
    //Write Disable
    writeByte(c_WRDI, SPI_val);
    //warte bis Schreiben beendet ist
    writeReady(SPI_val);

    return 0;
}


int readBytes(uint8_t *data, uint32_t address, int count, SPI_Values spi_val) {
    if (count > sizeof(data)) {
        return 1;
    }

    uint8_t command = c_READ;
    uint8_t tmp_add;
    //CS low
    MSS_GPIO_set_output(spi_val.CS_Pin, 0);
    //commando schicken
    MSS_SPI_transfer_frame(&g_mss_spi0, command);

    //4 Byte Addressse schicken MSB to LSB
    tmp_add = (uint8_t) ((address >> 24) & 0x000000FF);
    MSS_SPI_transfer_frame(&g_mss_spi0, tmp_add);

    tmp_add = (uint8_t) ((address >> 16) & 0x000000FF);
    MSS_SPI_transfer_frame(&g_mss_spi0, tmp_add);

    tmp_add = (uint8_t) ((address >> 8) & 0x000000FF);
    MSS_SPI_transfer_frame(&g_mss_spi0, tmp_add);

    tmp_add = (uint8_t) (address & 0x000000FF);
    MSS_SPI_transfer_frame(&g_mss_spi0, tmp_add);

    //Daten lesen
    for (int i = 0; i < count; i++) {
        data[i] = MSS_SPI_transfer_frame(&g_mss_spi0, 0x00);
    }

    //CS1 high
    MSS_GPIO_set_output(spi_val.CS_Pin, 1);

    return 0;
}

uint32_t UpdateMetadata(uint32_t pageAddr, uint32_t metaAddress, SPI_Values dev) {
    uint8_t buffer[PAGESIZE] = { 0 };
    uint32_t *ptr = (uint32_t*)buffer;
    uint32_t value = 0;
    uint32_t page;
    writeReady(dev);
    /*Iterate over all pages*/
    for (uint32_t i = metaAddress; i < START_OF_DATA_SEGMENT; i++) {
        readPage(buffer, i, dev);
        ptr = (uint32_t*)(buffer ); //Reset the ptr to the start of the buffer
        for (uint32_t index = 0; index < 128;index++) {
            value = *(ptr);
            if (value == 0xFFFFFFFF) {
                //system.metaAddressOffset = index;
                break;
            } else {
                ptr++;
            }

        }
        if (value == 0xFFFFFFFF) {
            *ptr = pageAddr; //Pointer was added due to search function implemented above, remove one
            writePage(buffer, i, dev);
            page = i;
            break;
        }
    }
    writeReady(dev);
    return page;
}

/**
 * Waits for the bit WIP (Write in Progress) bit to toggle
 * Reads SR1 register from memory
 */
void writeReady(SPI_Values SPI_val) {
    uint32_t status = 0;
    uint8_t SR1 = 0xF;
    while (status == 0) {
        SR1 = readStatus(SPI_val);
        if ((SR1 & 0x1) == 0)
            status = 1;
    }
}

/*
 * Copies the registers Stamp1Shadow1 - Stamp6Shadow2, SR, SR2, Timestamp to the internal memory
 * @param puffer pointer to a memory region of 512 byte
 * @param SRlocals missing three bits covering SODS SOE and LO signals to save them to memory
 * @return uint32_t the value of SR1 for interrupt reason examination after copying the data
 */
uint32_t CopyDataFabricToMaster(uint8_t *puffer, Telemmetry_t *telFrame, uint32_t SRlocals) {
    uint32_t SR1 = HW_get_32bit_reg(MEMORY_REG(SynchStatusReg));
    uint32_t local = 0;
    uint32_t *telFramePtr = (uint32_t*)(telFrame);
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
        local = HW_get_32bit_reg(MEMORY_REG(TimeStampReg));
        ptr32[MemoryPtrWatermark32Bit++] = local;
        telFrame->timestamp = local;
        telFramePtr++;
        /*Copy all the data */
        for (int i = LOWESTSTAMP; i <= HIGHESTSTAMP; i += 4) {
            local = HW_get_32bit_reg(MEMORY_REG(i));
            *(telFramePtr++) = local;
            ptr32[MemoryPtrWatermark32Bit++] = local;
            HW_set_32bit_reg(MEMORY_REG(i), 0x0); //Reset the stamp shadow registers
        }
        /* Add status registers */
        ptr32[MemoryPtrWatermark32Bit++] = SR1;
        telFrame->statusReg1 = SR1;
        local = HW_get_32bit_reg(MEMORY_REG(SynchStatusReg2));
        ptr32[MemoryPtrWatermark32Bit++] = local;
        telFrame->statusReg2 = local;
        /* Reset TimeStampReg, SR2, SR1 values */
        HW_set_32bit_reg(MEMORY_REG(TimeStampReg), 0x0);
        HW_set_32bit_reg(MEMORY_REG(SynchStatusReg2), 0x0);
        HW_set_32bit_reg(MEMORY_REG(SynchStatusReg), 0x0);
    }
    return SR1;
}

void Write32Bit(uint32_t value, uint32_t address, SPI_Values device) {
    writeByte(c_WREN, device);

    MSS_GPIO_set_output(device.CS_Pin, 0);

    MSS_SPI_transfer_frame(device.spihandle, c_WRITEPAGE);

    //Transfer address MSB to LSB
    uint8_t tmp_add = (uint8_t) ((address >> 24) & 0x000000FF);
    MSS_SPI_transfer_frame(device.spihandle, tmp_add);

    tmp_add = (uint8_t) ((address >> 16) & 0x000000FF);
    MSS_SPI_transfer_frame(device.spihandle, tmp_add);

    tmp_add = (uint8_t) ((address >> 8) & 0x000000FF);
    MSS_SPI_transfer_frame(device.spihandle, tmp_add);

    tmp_add = (uint8_t) (address & 0x000000FF);
    MSS_SPI_transfer_frame(device.spihandle, tmp_add);

    uint8_t *ptr= (uint8_t*)&value;
    for (int i = 0; i < 4; i++) {
        MSS_SPI_transfer_frame(device.spihandle,ptr[i]);
    }

// /* Transmit the value MSB to LSB*/
//    tmp_add = (uint8_t) ((value >> 24) & 0x000000FF);
//    MSS_SPI_transfer_frame(device.spihandle, tmp_add);
//
//    tmp_add = (uint8_t) ((value >> 16) & 0x000000FF);
//    MSS_SPI_transfer_frame(device.spihandle, tmp_add);
//
//    tmp_add = (uint8_t) ((value >> 8) & 0x000000FF);
//    MSS_SPI_transfer_frame(device.spihandle, tmp_add);
//
//    tmp_add = (uint8_t) (value & 0x000000FF);
//    MSS_SPI_transfer_frame(device.spihandle, tmp_add);
    MSS_GPIO_set_output(device.CS_Pin, 1);
    //Write disable
    writeByte(c_WRDI, device);
}

void WriteBytes(uint8_t *data, uint32_t size, uint32_t address,
        SPI_Values device) {
    if (data) {
        writeByte(c_WREN, device);

        MSS_GPIO_set_output(device.CS_Pin, 0);

        MSS_SPI_transfer_frame(device.spihandle, c_WRITEPAGE);

        //Transfer address MSB to LSB
        uint8_t tmp_add = (uint8_t) ((address >> 24) & 0x000000FF);
        MSS_SPI_transfer_frame(device.spihandle, tmp_add);

        tmp_add = (uint8_t) ((address >> 16) & 0x000000FF);
        MSS_SPI_transfer_frame(device.spihandle, tmp_add);

        tmp_add = (uint8_t) ((address >> 8) & 0x000000FF);
        MSS_SPI_transfer_frame(device.spihandle, tmp_add);

        tmp_add = (uint8_t) (address & 0x000000FF);
        MSS_SPI_transfer_frame(device.spihandle, tmp_add);

        for (int i = 0; i < size; i++) {
            MSS_SPI_transfer_frame(device.spihandle, data[i]);

        }
        MSS_GPIO_set_output(device.CS_Pin, 1);
        //Write disable
        writeByte(c_WRDI, device);
    }
}
