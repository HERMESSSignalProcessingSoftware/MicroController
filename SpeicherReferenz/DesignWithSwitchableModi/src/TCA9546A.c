
#include <cyu3i2c.h>
#include <cyu3error.h>

#include "../inc/TCA9546A.h"
#include "../inc/I2C_SensorBasics.h"
#include "../inc/userDebug.h"

/*
 * 0x00 disable all channels
 * 0x01 enable channel one only
 * 0x02 enable channel two only
 * 0x04 enable channel three only
 * 0x08 enable channel four only
 * add the numbers to enable more than on channel at the same time
 * get more information in datasheet tca9546a page 13
 */
CyU3PReturnStatus_t
TCA9546A_enableChannels
(
        uint8_t *data
)
{
    CyU3PReturnStatus_t apiRetStatus = CY_U3P_SUCCESS;
    CyU3PI2cPreamble_t  preamble;


    /* Set the parameters for the I2C API access and then call the write API. */
    preamble.buffer[0] = TCA9546A_I2C_ADDRESS_WRITE;
    preamble.length    = 1;             /*  Three byte preamble. */
    preamble.ctrlMask  = 0x0000;        /*  No additional start and stop bits. */

    apiRetStatus = CyU3PI2cTransmitBytes (&preamble, data, 1, 0);
    SensorI2CAccessDelay (apiRetStatus);

    if (apiRetStatus != CY_U3P_SUCCESS)
      errorPrint("fail to enable TCA9546A channel, Error Code = %d", apiRetStatus);

    return apiRetStatus;
}

CyU3PReturnStatus_t
TCA9546A_readChannels
(
    uint8_t *data
)
{
  CyU3PReturnStatus_t apiRetStatus = CY_U3P_SUCCESS;
  CyU3PI2cPreamble_t preamble;


  preamble.buffer[0] = TCA9546A_I2C_ADDRESS_READ;        /*  Mask out the transfer type bit. */
  preamble.length    = 1;
  preamble.ctrlMask  = 0x0000;

  apiRetStatus = CyU3PI2cReceiveBytes (&preamble, data, 1, 0);
  SensorI2CAccessDelay (apiRetStatus);

  if (apiRetStatus != CY_U3P_SUCCESS)
    errorPrint("fail to read TCA9546A channel, Error Code = %d", apiRetStatus);

  return apiRetStatus;
}
