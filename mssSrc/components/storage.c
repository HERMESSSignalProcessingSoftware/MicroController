/**
 * storage.c
 * 
 * Created on: 17.10.2021
 * Author: Robin Grimsmann
 * 
 * */

#include "storage.h"

void InitSPI(uint32_t erase) {
      /* Do the SPI init */
    MSS_SPI_init(&g_mss_spi0);
    MSS_SPI_configure_master_mode(&g_mss_spi0, MSS_SPI_SLAVE_0, MSS_SPI_MODE0,
            16u, MSS_SPI_BLOCK_TRANSFER_FRAME_SIZE);
    /* Do set the nCSx signals to high */
    MSS_GPIO_set_output(nCS1, 1);
    MSS_GPIO_set_output(nCS2, 1);
    MSS_SPI_set_slave_select(&g_mss_spi0, MSS_SPI_SLAVE_0);

    /*DO this once */
    if (erase == DO_ERASE) {
        SPI_Values cErease;
        cErease.spihandle = &g_mss_spi0;
        cErease.CS_Pin = nCS1;
        chipErase(cErease);
        cErease.CS_Pin = nCS2;
        chipErase(cErease);
    }
}

MemoryConfig Recovery(void) {
    MemoryConfig mC = {0};
    mC.RecoverySuccess = 0;
    uint8_t buffer[512] = {0};
    SPI_Values dev;
    dev.spihandle = &g_mss_spi0;
    dev.CS_Pin = nCS1;
    uint32_t *ptr = (uint32_t*)buffer;
    uint32_t nextOneHits = 0;
    uint32_t pageCounter = 0;
    for (int i = 0; i < 0x200; i++) {
        readPage(buffer, i, dev);
        /* Look at every 4 bytes*/
        for (int j = 0; j < 128; j++) {
            if (ptr[j] == 0xFFFFFFFF) { /* the value before is the last, saved page address*/
                 uint32_t t = ptr[j];
                 nextOneHits = j - 1;
                 break;
            }
        }

        if (nextOneHits != 0) {
            uint32_t value = ptr[nextOneHits];
//            uint32_t reverse = (value >> 24) & 0x000000FF;
//            reverse |= (value >> 8) & 0x0000FF00;
//            reverse |= (value << 8) & 0x00FF0000;
//            reverse |= (value << 16) & 0xFF000000;
            mC.CurrentPage = value + 125;
            mC.StartPage = value + 125;
            mC.MetaAddress = pageCounter + nextOneHits + 4;
            mC.RecoverySuccess = 1;
            break;
        }
        pageCounter++;
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
    for (int i = 0; i < PAGESIZE; i++) {
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