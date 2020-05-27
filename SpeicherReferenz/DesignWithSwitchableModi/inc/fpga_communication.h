#ifndef _INCLUDED_FPGA_COMMUNICTATION_H_
#define _INCLUDED_FPGA_COMMUNICTATION_H_

#define FPGA_I2C_ADDRESS        0x78
#define FPGA_I2C_ADDRESS_WRITE  0x78
#define FPGA_I2C_ADDRESS_READ   0x79


CyU3PReturnStatus_t
fpgaReadI2CRegister
(
    uint8_t address,
    uint8_t *data
);

CyU3PReturnStatus_t
fpgaWriteI2CRegister
(
    uint8_t address,
    uint8_t data
);

#endif
