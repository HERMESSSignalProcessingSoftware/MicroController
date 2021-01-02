//Commands
#define CMD_WAKEUP      0x01 //exit sleep mode
#define CMD_SLEEP       0x02 //enter sleep mode
#define CMD_SYNC        0x04 //synchronize the A/D conversion
#define CMD_RESET       0x06 //reset to power-up values
#define CMD_NOP         0xFF //no operation
#define CMD_RDATA       0x12 //read data once
#define CMD_RDATAC      0x14 //read data continuously
#define CMD_SDATAC      0x16 //stop reading data continuously
#define CMD_RREG        0x20 //read from register
#define CMD_WREG        0x40 //write to register
#define CMD_SYSOCAL     0x60 //system offset calibration
#define CMD_SYSGCAL     0x61 //system gain calibration
#define CMD_SELFOCAL    0x62 //self offset calibration

//Registers
#define REG_MUX0        0x00
#define REG_VBIAS       0x01
#define REG_MUX1        0x02
#define REG_SYS0        0x03
#define REG_OFC0        0x04
#define REG_OFC1        0x05
#define REG_OFC2        0x06
#define REG_FSC0        0x07
#define REG_FSC1        0x08
#define REG_FSC2        0x09
#define REG_IDAC0       0x0A
#define REG_IDAC1       0x0B
#define REG_GPIOCFG     0x0C
#define REG_GPIODIR     0x0D
#define REG_GPIODAT     0x0E

//Multiplexer Control Register 0
#define MUX0_SN0        (0<<0)
#define MUX0_SN1        (1<<0)
#define MUX0_SN2        (2<<0)
#define MUX0_SN3        (3<<0)
#define MUX0_SP0        (0<<3)
#define MUX0_SP1        (1<<3)
#define MUX0_SP2        (2<<3)
#define MUX0_SP3        (3<<3)
#define MUX0_BCSOFF     (0<<6)
#define MUX0_BCS05UA    (1<<6)
#define MUX0_BCS2UA     (2<<6)
#define MUX0_BCS10UA    (3<<6)

//Bias Voltage Register
#define VBIAS_OFF       (0x00)
#define VBIAS_AIN0      (1<<0)
#define VBIAS_AIN1      (1<<1)
#define VBIAS_AIN1      (1<<2)
#define VBIAS_AIN1      (1<<3)

//Multiplexer Control Register 1
#define MUX1_CALNORMAL  (0<<0) //normal operation, PGA gain set by SYS0
#define MUX1_CALOFFSET  (1<<0) //offset measurement, PGA gain set by SYS0
#define MUX1_CALGAIN    (2<<0) //gain measurement, PGA gain 1
#define MUX1_CALTEMP    (3<<0) //temperature measurement, PGA gain 1
#define MUX1_CALREF1    (4<<0) //ext. REF1 measurement, PGA gain 1
#define MUX1_CALREF0    (5<<0) //ext. REF0 measurement, PGA gain 1
#define MUX1_CALAVDD    (6<<0) //AVDD measurement, PGA gain 1
#define MUX1_CALDVDD    (7<<0) //DVDD measurement, PGA gain 1
#define MUX1_REF0       (0<<3) //REF0 input pair selected
#define MUX1_REF1       (1<<3) //REF1 input pair selected
#define MUX1_REFOB      (2<<3) //0nboard reference selected
#define MUX1_REF0OB     (3<<3) //0nboard reference selected and internally connected to REF0 input pair
#define MUX1_INTREFOFF  (0<<5) //internal reference is always off
#define MUX1_INTREFON   (1<<5) //internal reference is always on
#define MUX1_INTREFONC  (2<<5) //internal reference is on when a conversion is in progress
#define MUX1_INTOSC     (0<<7) //internal oscillator
#define MUX1_EXTOSC     (0<<7) //external oscillator

//System Control Register 0
#define SYS0_DOR5       (0<<0) //   5 SPS
#define SYS0_DOR10      (1<<0) //  10 SPS
#define SYS0_DOR20      (2<<0) //  20 SPS
#define SYS0_DOR40      (3<<0) //  40 SPS
#define SYS0_DOR80      (4<<0) //  80 SPS
#define SYS0_DOR160     (5<<0) // 160 SPS
#define SYS0_DOR320     (6<<0) // 320 SPS
#define SYS0_DOR640     (7<<0) // 640 SPS
#define SYS0_DOR1000    (8<<0) //1000 SPS
#define SYS0_DOR2000    (9<<0) //2000 SPS
#define SYS0_PGA1       (0<<4)
#define SYS0_PGA2       (1<<4)
#define SYS0_PGA4       (2<<4)
#define SYS0_PGA8       (3<<4)
#define SYS0_PGA16      (4<<4)
#define SYS0_PGA32      (5<<4)
#define SYS0_PGA64      (6<<4)
#define SYS0_PGA128     (7<<4)

//IDAC Control Register 0
#define IDAC0_MAGOFF    (0<<0)
#define IDAC0_MAG50UA   (1<<0)
#define IDAC0_MAG100UA  (2<<0)
#define IDAC0_MAG250UA  (3<<0)
#define IDAC0_MAG500UA  (4<<0)
#define IDAC0_MAG750UA  (5<<0)
#define IDAC0_MAG1000UA (6<<0)
#define IDAC0_MAG1500UA (7<<0)
#define IDAC0_DOUT      (0<<3) //DOUT/DRDY pin -> Data Out
#define IDAC0_DOUTDRDY  (1<<3) //DOUT/DRDY pin -> Data Out and Data Ready (active low)

//IDAC Control Register 1
#define IDAC1_I2DIR0    (0<<0)
#define IDAC1_I2DIR1    (1<<0)
#define IDAC1_I2DIR2    (2<<0)
#define IDAC1_I2DIR3    (3<<0)
#define IDAC1_I2DIROFF  (15<<0)
#define IDAC1_I1DIR0    (0<<4)
#define IDAC1_I1DIR1    (1<<4)
#define IDAC1_I1DIR2    (2<<4)
#define IDAC1_I1DIR3    (3<<4)
#define IDAC1_I1DIROFF  (15<<4)
