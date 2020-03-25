// S70FL01GS.cpp

#include"S70FL01GS.h"

// CONSTRUCTOR
S70FL01GS::S70FL01GS(PinName mosi, PinName miso, PinName sclk, PinName cs) : SPI(mosi, miso, sclk), _cs(cs)
{
    this->format(SPI_NBIT, SPI_MODE);
    this->frequency(SPI_FREQ);
    chipDisable();
}
// READING
int S70FL01GS::readByte(int addr)
{
    chipEnable();
    this->write(FOUR_READ);
    this->write((addr & ADDR_BMASK3) >> ADDR_BSHIFT3);
    this->write((addr & ADDR_BMASK2) >> ADDR_BSHIFT2);
    this->write((addr & ADDR_BMASK1) >> ADDR_BSHIFT1);
    this->write((addr & ADDR_BMASK0) >> ADDR_BSHIFT0);
    int response = this->write(DUMMY_ADDR);
    chipDisable();
    return response;
}

void S70FL01GS::readStream(int addr, char* buf, int count)
{
    if (count < 1)
        return;
    chipEnable();
    this->write(FOUR_READ);
    this->write((addr & ADDR_BMASK3) >> ADDR_BSHIFT3);
    this->write((addr & ADDR_BMASK2) >> ADDR_BSHIFT2);
    this->write((addr & ADDR_BMASK1) >> ADDR_BSHIFT1);
    this->write((addr & ADDR_BMASK0) >> ADDR_BSHIFT0);
    for (int i = 0; i < count; i++) {
        buf[i] =  this->write(DUMMY_ADDR);
        printf("i= %d   :%c \r\n",i,buf[i]);
    }
    chipDisable();
}

// WRITING
void S70FL01GS::writeByte(int addr, int data)
{
    writeEnable();
    chipEnable();
    this->write(FOUR_PP);
    this->write((addr & ADDR_BMASK3) >> ADDR_BSHIFT3);
    this->write((addr & ADDR_BMASK2) >> ADDR_BSHIFT2);
    this->write((addr & ADDR_BMASK1) >> ADDR_BSHIFT1);
    this->write((addr & ADDR_BMASK0) >> ADDR_BSHIFT0);
    this->write(data);
    chipDisable();
    writeDisable();
    // wait(WAIT_TIME);//instead of wait poll for WIP flag of status reg or use checkIfBusy() function...see main for more dtails 
}

void S70FL01GS::writeStream(int addr, char* buf, int count)
{
    if (count < 1)
        return;
    writeEnable();
    wait(0.1);
    chipEnable();
    this->write(FOUR_PP);
    this->write((addr & ADDR_BMASK3) >> ADDR_BSHIFT3);
    this->write((addr & ADDR_BMASK2) >> ADDR_BSHIFT2);
    this->write((addr & ADDR_BMASK1) >> ADDR_BSHIFT1);
    this->write((addr & ADDR_BMASK0) >> ADDR_BSHIFT0);
    for (int i = 0; i < count; i++) {
        this->write(buf[i]);
    }
    wait(0.1);
    chipDisable();
    writeDisable();
    wait(WAIT_TIME);
}

void S70FL01GS::writeString(int addr, string str)
{
    if (str.length() < 1)
        return;
    writeEnable();
    chipEnable();
    this->write(FOUR_PP);
    this->write((addr & ADDR_BMASK3) >> ADDR_BSHIFT3);
    this->write((addr & ADDR_BMASK2) >> ADDR_BSHIFT2);
    this->write((addr & ADDR_BMASK1) >> ADDR_BSHIFT1);
    this->write((addr & ADDR_BMASK0) >> ADDR_BSHIFT0);
    for (int i = 0; i < str.length(); i++)
        this->write(str.at(i));
    chipDisable();
    writeDisable();
    wait(WAIT_TIME);//instead of wait poll for WIP flag of status reg or use checkIfBusy() function...see main for more dtails 
}



uint8_t S70FL01GS::readRegister()
{

    chipEnable();
    this->write(RDSR1);
    uint8_t val=this->write(DUMMY_ADDR);
    chipDisable();
   //wait(WAIT_TIME);//instead of wait poll for WIP flag of status reg or use checkIfBusy() function...see main for more dtails 
    //printf("value of reg is %X  \r\n",val);
    return(val);

}
//ERASING
void S70FL01GS::chipErase()
{
    writeEnable();
    chipEnable();
    this->write(BE);
    chipDisable();
    writeDisable();
    wait(WAIT_TIME);//instead of wait poll for WIP flag of status reg or use checkIfBusy() function...see main for more dtails 
}

void S70FL01GS::Read_Identification(uint8_t *buf)
{


    chipEnable();
    this->write(RDID);
    for(int i=0; i<80; i++)
        buf[i]=this->write(DUMMY_ADDR);
    chipDisable();
    wait(WAIT_TIME);//instead of wait poll for WIP flag of status reg or use checkIfBusy() function...see main for more dtails 
}

void S70FL01GS::sectorErase(int addr)
{
    writeEnable();
    chipEnable();
    this->write(FOUR_SE);
    this->write((addr & ADDR_BMASK3) >> ADDR_BSHIFT3);
    this->write((addr & ADDR_BMASK2) >> ADDR_BSHIFT2);
    this->write((addr & ADDR_BMASK1) >> ADDR_BSHIFT1);
    this->write((addr & ADDR_BMASK0) >> ADDR_BSHIFT0);
    chipDisable();
    writeDisable();
    wait(WAIT_TIME);//instead of wait poll for WIP flag of status reg or use checkIfBusy() function...see main for more dtails 
}
void S70FL01GS::reset()
{
    writeEnable();
    chipEnable();
    this->write(RESET);
    chipDisable();
    writeDisable();
}

uint8_t S70FL01GS::checkIfBusy()
{
    uint8_t value=readRegister();
    printf("Value of Status Reg=%X\r\n\r\n",value);
    if((value&0x01)==0x01)
        return 1;
    else
        return 0;

}
void S70FL01GS::writeRegister(uint8_t regValue)
{
    writeEnable();
    chipEnable();
    this->write(WRR);
    this->write(regValue);
    chipDisable();
    writeDisable();
    wait(WAIT_TIME);//instead of wait poll for WIP flag of status reg or use checkIfBusy() function...see main for more dtails 

}

void S70FL01GS::clearRegister(void)
{
    writeEnable();
    chipEnable();
    this->write(CLSR);
    chipDisable();
    writeDisable();
    wait(WAIT_TIME);//instead of wait poll for WIP flag of status reg or use checkIfBusy() function...see main for more dtails 

}


void S70FL01GS::writeLong(int addr, long value)
{
    //Decomposition from a long to 4 bytes by using bitshift.
    //One = Most significant -> Four = Least significant byte
    uint8_t four = (value & 0xFF);
    uint8_t three = ((value >> 8) & 0xFF);
    uint8_t two = ((value >> 16) & 0xFF);
    uint8_t one = ((value >> 24) & 0xFF);

    writeEnable();
    chipEnable();
    this->write(FOUR_PP);
    this->write((addr & ADDR_BMASK3) >> ADDR_BSHIFT3);
    this->write((addr & ADDR_BMASK2) >> ADDR_BSHIFT2);
    this->write((addr & ADDR_BMASK1) >> ADDR_BSHIFT1);
    this->write((addr & ADDR_BMASK0) >> ADDR_BSHIFT0);
    this->write(four);
    this->write(three);
    this->write(two);
    this->write(one);
    chipDisable();
    writeDisable();
    wait(0.1);
}

long S70FL01GS::readLong(int addr)
{
    //Read the 4 bytes from the eeprom memory.
    writeEnable();
    chipEnable();
    this->write(FOUR_READ);
    this->write((addr & ADDR_BMASK3) >> ADDR_BSHIFT3);
    this->write((addr & ADDR_BMASK2) >> ADDR_BSHIFT2);
    this->write((addr & ADDR_BMASK1) >> ADDR_BSHIFT1);
    this->write((addr & ADDR_BMASK0) >> ADDR_BSHIFT0);

    long four = this->write(DUMMY_ADDR);
    long three = this->write(DUMMY_ADDR);
    long two = this->write(DUMMY_ADDR);
    long one = this->write(DUMMY_ADDR);
    chipDisable();
    writeDisable();
    wait(0.1);

    //Return the recomposed long by using bitshift.
    return ((four << 0) & 0xFF) + ((three << 8) & 0xFFFF) + ((two << 16) & 0xFFFFFF) + ((one << 24) & 0xFFFFFFFF);
}


//ENABLE/DISABLE (private functions)
void S70FL01GS::writeEnable()
{
    chipEnable();
    this->write(WREN);
    chipDisable();
}
void S70FL01GS::writeDisable()
{
    chipEnable();
    this->write(WRDI);
    chipDisable();
}
void S70FL01GS::chipEnable()
{
    _cs = 0;
}
void S70FL01GS::chipDisable()
{
    _cs = 1;
}

