/*
 * Memory.c
 *
 *  Created on: Jun 17, 2021
 *      Author: Robin Grimsmann
 */

#include "MemoryRev2.h"
#include <stdio.h>
#include "../../drivers/mss_gpio/mss_gpio.h"

#define PAGE_COUNT 125000

void InitSPIMemory(void) {
    /* Set disable the not ABP part of this component*/
    DisableMemorySync();
    MSS_GPIO_config(OUT_ENA_MEMORY_CU, MSS_GPIO_OUTPUT_MODE);

    /* Do the SPI init */
    MSS_SPI_init(&g_mss_spi0);
    MSS_SPI_configure_master_mode(&g_mss_spi0, MSS_SPI_SLAVE_0, MSS_SPI_MODE0, 16u, MSS_SPI_BLOCK_TRANSFER_FRAME_SIZE);

    /* Do set the nCSx signals to high */
    MSS_GPIO_set_output(nCS1, 1);
    MSS_GPIO_set_output(nCS2, 1);
    MSS_SPI_set_slave_select(&g_mss_spi0, MSS_SPI_SLAVE_0);

    /* Init via APB */
    uint32_t ConfigRegValue = CONFIG_REG_ENABLE_INTERRUPT;
    ConfigRegValue  |= CONFIG_REG_NUMBER_OF_NEW_AVAILABLES(4);
    ConfigRegValue  |= CONFIG_REG_NUMBER_OF_REQUEST_RESNYCS(4);
    HW_set_32bit_reg(MEMORY_REG(ConfigReg), ConfigRegValue);
    /* Programm the Waiting Value of S1 to 500 (20us)*/
    HW_set_32bit_reg(MEMORY_REG(WaitingTimerValueReg), 0x000001F4);
    /* Wait for 2 ms after each Resync Event */
    HW_set_32bit_reg(MEMORY_REG(ResyncTimerValueReg), 0x0000C350);
    /* Set the Reset Timer to 500 ms*/
    HW_set_32bit_reg(MEMORY_REG(ResyncTimerValueReg), 0x00bebc20);
}


/*
 * Enables the FSM of the memory synchronizer
 *
 */
void __inline EnableMemorySync(void) {
    MSS_GPIO_set_output(OUT_ENA_MEMORY_CU, 1);
}

/*
 * Disables the FSM of the memory synchronizer
 */
void __inline DisableMemorySync(void) {
    MSS_GPIO_set_output(OUT_ENA_MEMORY_CU, 0);
}


/**
 * Performes a fast memory test, just writes one page and reads it
 *
 */
uint32_t FastMemoryTest(void) {

    char writeBuffer[256] = "Starting FLASH Test...\r\n";
    spuLog(writeBuffer);

    SPI_Values DUT0;
    DUT0.CS_Pin = nCS1;
    DUT0.spihandle = &g_mss_spi0;
    //
    SPI_Values DUT1;
    DUT1.CS_Pin = nCS2;
    DUT1.spihandle = &g_mss_spi0;

//

    uint32_t result = 0;
    uint32_t startTime = 0;
    uint32_t endTime = 0;
    uint32_t kbits = 0;

    sprintf(writeBuffer, "\t%s\n\r\0", "Checking FL2/1");
    spuLog(writeBuffer);
    result = FastTest(DUT0);
    sprintf(writeBuffer, "\t\tResult: %s\r\n\0",
            result == 1 ? "Passed" : "Failed");
    spuLog(writeBuffer);
    delay(50);

    sprintf(writeBuffer, "\t%s\n\r\0", "Checking FL2/1");
    spuLog(writeBuffer);
    result = FastTest(DUT1);
    sprintf(writeBuffer, "\t\tResult: %s\r\n\0",
            result == 1 ? "Passed" : "Failed");
    spuLog(writeBuffer);
    delay(50);

    return 0;
}

uint32_t FastTest(SPI_Values spi_val) {
    uint8_t writeBuffer[256] = { 0 };
    uint8_t readBuffer[256] = { 0 };
    uint32_t adresse = 1;
    volatile uint8_t SR1;
    //Testdaten initialisieren
    for (int i = 0; i < 256; i++) {
        writeBuffer[i] = i;
    }

    //CHIP löschen
    //chipErase(DUT);
    //evtl Zusätzliche Schleife für die verschiedenen Chips und CS pin
    //Daten für eine Page schicken
    writePage(writeBuffer, adresse, spi_val);
    //Warten bis fertig geschrieben wurde
    writeReady(spi_val);
    //Selbe page auslesen
    readPage(readBuffer, adresse, spi_val);
    //Inhalt vergleichen
    for (int y = 0; y < 256; y++) {
        //Wenn inhalt nicht gleich
        if (writeBuffer[y] != readBuffer[y]) {
            SR1 = readStatus(spi_val);
            return 0;
        }
    }
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
    uint8_t recBuffer[256] = { 0 };
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
    for (int i = 0; i < 256; i++) {
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
 * Byte:    0 - 256
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
    //  HAL_SPI_Receive(SPI_val.spihandle, data, 256, 2560);
    for (int i = 0; i < 256; i++) {
        data[i] = MSS_SPI_transfer_frame(&g_mss_spi0, 0x00);
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

/* TODO: DOCUMENTATION!!
 *  UNDOCUMENTED
 * */
int readBytes(uint8_t *data, uint32_t address, int count,
        SPI_Values spi_val) {

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


