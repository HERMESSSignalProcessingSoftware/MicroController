#include "adc.h"
#include "main.h"
#include "gpio.h"
#include "spi.h"
#include "stm32f7xx_hal.h"

uint8_t ADS1147::begin(uint_least8_t drate, uint_least8_t gain, uint_least16_t current)
{
  uint_least8_t r;

  //init pins
  //pinMode(CS_PIN, OUTPUT);
  //pinMode(SCK_PIN, OUTPUT);
  //pinMode(MOSI_PIN, OUTPUT);
  //pinMode(MISO_PIN, INPUT);
  HAL_GPIO_WritePin(CS_PORT, CS_PIN, GPIO_PIN_SET);

  //init SPI
#if !defined(SOFTWARE_SPI)
  SPI.begin();
#endif

  //init ADS
  switch(drate)
  {
    case    5: drate = SYS0_DOR5;    break;
    case   10: drate = SYS0_DOR10;   break;
    case   20: drate = SYS0_DOR20;   break;
    default:
    case   40: drate = SYS0_DOR40;   break;
    case   80: drate = SYS0_DOR80;   break;
    case  160: drate = SYS0_DOR160;  break;
    case  320: drate = SYS0_DOR320;  break;
    case  640: drate = SYS0_DOR640;  break;
    case 1000: drate = SYS0_DOR1000; break;
    case 2000: drate = SYS0_DOR2000; break;
  }

  switch(gain)
  {
    default:
    case   1: gain = SYS0_PGA1;   break;
    case   2: gain = SYS0_PGA2;   break;
    case   4: gain = SYS0_PGA4;   break;
    case   8: gain = SYS0_PGA8;   break;
    case  16: gain = SYS0_PGA16;  break;
    case  32: gain = SYS0_PGA32;  break;
    case  64: gain = SYS0_PGA64;  break;
    case 128: gain = SYS0_PGA128; break;
  }

  switch(current)
  {
    default:
    case    0: current = IDAC0_MAGOFF;    break;
    case   50: current = IDAC0_MAG50UA;   break;
    case  100: current = IDAC0_MAG100UA;  break;
    case  250: current = IDAC0_MAG250UA;  break;
    case  500: current = IDAC0_MAG500UA;  break;
    case  750: current = IDAC0_MAG750UA;  break;
    case 1000: current = IDAC0_MAG1000UA; break;
    case 1500: current = IDAC0_MAG1500UA; break;
  }

  wr_cmd(CMD_RESET);
  wr_cmd(CMD_SELFOCAL);
  r = (rd_reg(REG_IDAC0)&0xF0)>>4; //read revision
  wr_reg(REG_MUX0, MUX0_BCSOFF | MUX0_SP0 | MUX0_SN1);
  wr_reg(REG_VBIAS, VBIAS_OFF);
  wr_reg(REG_MUX1, MUX1_INTOSC | MUX1_INTREFON | MUX1_REF0 | MUX1_CALNORMAL);
  wr_reg(REG_SYS0, gain | drate);
  wr_reg(REG_IDAC0, IDAC0_DOUTDRDY | current);
  wr_reg(REG_IDAC1, IDAC1_I1DIROFF | IDAC1_I2DIROFF);

  return r;
}

void wr_cmd(){

}

void wr_reg(){

}

void rd_reg(){

}




