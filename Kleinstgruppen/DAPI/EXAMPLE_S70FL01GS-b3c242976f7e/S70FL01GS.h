// S70FL01GS.h

#ifndef S70FL01GS_H
#define S70FL01GS_H

#include "mbed.h"
#include <string>

#define SPI_FREQ        5000000                 //Change SPI Frequency Here
#define SPI_MODE        0                       // SPI Mode can be 0 or 3 . see data sheet
#define SPI_NBIT        8                       // Number of bits 8.



#define DUMMY_ADDR      0x00
#define WAIT_TIME       1

#define ADDR_BMASK3     0xff000000
#define ADDR_BMASK2     0x00ff0000
#define ADDR_BMASK1     0x0000ff00
#define ADDR_BMASK0     0x000000ff

#define ADDR_BSHIFT3    24
#define ADDR_BSHIFT2    16
#define ADDR_BSHIFT1    8
#define ADDR_BSHIFT0    0

#define RDSR1               0x05                // 6th bit P_ERR  Program Error-->1, NO error 0
                                                //5th bit E_ERR  Program Error-->1, No ERROR 0
                                                //0th  WIP --> 1 indicates Busy Writing, 0--> Free, Done
                                                // read Bits 6,5,0
#define READ_ID             0x90                // Read Electronic Manufacturer Signature
#define RDID                0x9F                //Read ID (JEDEC Manufacturer ID and JEDEC CFI)
#define RES                 0xAB                // Read Electronic Signature

//4 Byte  Address4PP 12h)

#define FOUR_FAST_READ      0x0C                //Read Fast (4-byte Address) 0C
#define FOUR_READ           0x13                //Read (4-byte Address)
#define FOUR_DOR            0x3C                //Read Dual Out (FOUR_-byte Address) 3C
#define FOUR_QOR            0x6C                //Read Quad Out (FOUR_-byte Address)
#define FOUR_DIOR           0xBC                // Dual I/O Read (FOUR_-byte Address) BC
#define FOUR_QIOR           0xEC                //FOUR_QIOR Quad I/O Read (FOUR_-byte Address) EC
#define FOUR_DDRFR          0x0E                //Read DDR Fast (FOUR_-byte Address) 
#define FOUR_DDRDIOR        0xBE                // DDR Dual I/O Read (FOUR_-byte Address) BE
#define FOUR_DDRQIOR        0xEE  
#define FOUR_PP             0x12                // FOUR_PP Page Program (FOUR_-byte Address) 12
#define FOUR_QPP            0x34                //Quad Page Program (FOUR_-byte Address)  
#define FOUR_P4E            0x21                // Parameter 4-kB Erase (4-byte Address) 21
#define FOUR_SE             0xDC                // Erase 64/256 kB (4-byte Address) DC

//3 Byte Address

#define READ            0x03                    //READ Read (3-byte Address) 03
#define FAST_READ       0x0B                    //FAST_READ Read Fast (3-byte Address) 0B
#define DOR             0x3B                    //DOR Read Dual Out (3-byte Address) 3B
#define Q0R             0x6B                    //QOR Read Quad Out (3-byte Address) 6B   
#define DIOR            0xBB                    //DIOR Dual I/O Read (3-byte Address) BB  
#define QIOR            0xEB                    //QIOR Quad I/O Read (3-byte Address) EB
#define DDRFR           0x0D                    //DDRFR Read DDR Fast (3-byte Address) 0D
#define DDRDIOR         0xBD                    //DDRDIOR DDR Dual I/O Read (3-byte Address) BD
#define DDRQIOR         0xED                    //DDRQIOR DDR Quad I/O Read (3-byte Address) ED
#define PP              0x02                    //PP Page Program (3-byte Address) 02
#define Qpp             0x32                    //QPP Quad Page Program (3-byte Address) 32
#define P4E             0x20                    //P4E Parameter 4-kB Erase (3-byte Address) 20
#define SE              0xD8                    //SE Erase 64 / 256 kB (3-byte Address) D8
#define BE              0x60                    // Erase Entire Chip.

#define RDSR1           0x05                    //RDSR1 Read Status Register-1 05 
#define RDSR2           0x07                    //RDSR2 Read Status Register-2 07 
#define RDCR            0x35                    //RDCR Read Configuration Register-1 35 
#define WRR             0x01                    //Write Register (Status-1, Configuration-1)  
#define WRDI            0x04                    //Write Disable 04 
#define WREN            0x06                    //WREN Write Enable 06 
#define CLSR            0x30                    //CLSR Clear Status Register-1 - Erase/Prog. Fail Reset 30 
#define ECCRD           0x18                    //ECCRD ECC Read (4-byte address) 18 
#define ABRD            0x14                    //ABRD AutoBoot Register Read 14
#define ABWR            0x15                    //AutoBoot Register Write 15 
#define BRRD            0x16                    //Bank Register Read 16 
#define BRWR            0x17                    //Bank Register Write 17 
#define BRAC            0xB9                    //BRAC Bank Register Access (Legacy Command formerly used for Deep Power Down) B9
#define DLPRD           0x41                    //DLPRD Data Learning Pattern Read 41 
#define PNVDLR          0x43                    //PNVDLR Program NV Data Learning Register 43   
#define WVDLR           0x4A                    //Write Volatile Data Learning Register 4A 
#define PGSP            0x85                    //Program Suspend 85 
#define PGRS            0x8A                    //Program Resume 8A 
#define ERSP            0x75                    //Erase Suspend 75 
#define ERRS            0x7A                    //Erase Resume 7A 
#define OTPP            0x42                    //OTP Program 42
#define OTPR            0x4B                    //OTP Read 4B 

//Advanced Sector Protection

#define DYBRD           0xE0                    //DYB Read E0 133
#define DYBWR           0xE1                    //DYB Write E1 133
#define PPBRD           0xE2                    //PPB Read E2 133
#define PPBP            0xE3                    //PPB Program E3 133
#define PPBE            0xE4                    //PPB Erase E4 133
#define ASPRD           0x2B                    //ASP Read 2B 133
#define ASPP            0x2F                    //ASP Program 2F 133
#define PLBRD           0xA7                    //PPB Lock Bit Read A7 133
#define PLBWR           0xA6                    //PPB Lock Bit Write A6 133
#define PASSRD          0xE7                    //Password Read E7 133
#define PASSP           0xE8                    //Password Program E8 133
#define PASSU           0xE9                    //Password Unlock E9 133
#define DUMMY           0x00                    // Dummy write to read
//Reset

#define RESET           0xF0                    //Software Reset F0 133
#define MBR             0xFF                    //Mode Bit Reset FF 133
#define DUMMYBYTE       0x00                    //Dummy byte for Read Operation

class S70FL01GS: public SPI {
public:
    S70FL01GS(PinName mosi, PinName miso, PinName sclk, PinName cs);
    
    int readByte(int addr);                                 // takes a 32-bit (4 bytes) address and returns the data (1 byte) at that location                   
    void readStream(int addr, char* buf, int count);        // takes a 32-bit address, reads count bytes, and stores results in buf
    
    void writeByte(int addr, int data);                     // takes a 32-bit (4 bytes) address and a byte of data to write at that location
    void writeStream(int addr, char* buf, int count);       // write count bytes of data from buf to memory, starting at addr  
    void writeString(int add, string str);
    void sectorErase(int addr);
    void chipErase();                                       //erase all data on chip
    uint8_t readRegister();  
    uint8_t checkIfBusy();                                  // Check if IC is bury writing or erasing 
    void writeRegister(uint8_t regValue);                   // Write status register or configuration register
    void reset(void);                                       // Reset Chip
    void clearRegister();                                   // Clear Status Register
    void Read_Identification(uint8_t *buf);
    long raedLong(int address);                             // Read long int number
    void writeLong(int addr, long value);                   // Write Long Integer Number
private:
    void writeEnable();                                     // write enable
    void writeDisable();                                    // write disable
    void chipEnable();                                      // chip enable
    void chipDisable();  
                                      // chip disable
    
   // SPI _spi;
    DigitalOut _cs;
};

#endif