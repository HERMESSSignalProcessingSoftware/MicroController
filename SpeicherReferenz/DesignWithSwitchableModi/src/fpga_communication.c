
#include <cyu3i2c.h>
#include <cyu3error.h>

#include "../inc/fpga_communication.h"
#include "../inc/I2C_SensorBasics.h"
#include "../inc/userDebug.h"


CyU3PReturnStatus_t
fpgaWriteI2CRegister
(
    uint8_t address,
    uint8_t data
)
{
  CyU3PReturnStatus_t apiRetStatus = CY_U3P_SUCCESS;
  CyU3PI2cPreamble_t preamble;


  /* Set the parameters for the I2C API access and then call the write API. */
  preamble.buffer[0] = FPGA_I2C_ADDRESS;
  preamble.buffer[1] = address;
  preamble.length    = 2;
  preamble.ctrlMask  = 0x0000;

  apiRetStatus = CyU3PI2cTransmitBytes (&preamble, &data, 1, 0);
  SensorI2CAccessDelay (apiRetStatus);

  if (apiRetStatus != CY_U3P_SUCCESS)
    errorPrint("fail to write FPGA register at the address %d, Error Code = %d", address, apiRetStatus);

  return apiRetStatus;
}

CyU3PReturnStatus_t
fpgaReadI2CRegister
(
    uint8_t address,
    uint8_t *data
)
{
  CyU3PReturnStatus_t apiRetStatus = CY_U3P_SUCCESS;
  CyU3PI2cPreamble_t preamble;


  preamble.buffer[0] = FPGA_I2C_ADDRESS;
  preamble.buffer[1] = address;
  preamble.buffer[2] = FPGA_I2C_ADDRESS_READ;
  preamble.length    = 3;
  preamble.ctrlMask  = 0x0002;

  apiRetStatus = CyU3PI2cReceiveBytes (&preamble, data, 1, 0);
  SensorI2CAccessDelay (apiRetStatus);

  if (apiRetStatus != CY_U3P_SUCCESS)
    errorPrint("fail to read FPGA register at the address %d, Error Code = %d", address, apiRetStatus);

  return apiRetStatus;
}
