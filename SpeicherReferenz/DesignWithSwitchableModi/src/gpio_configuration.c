
#include <cyu3error.h>
#include <cyu3lpp.h>
#include <cyu3gpio.h>

#include "../inc/uvc.h"
#include "../inc/userDebug.h"
#include "../inc/criticalErrorHandler.h"

#include "../inc/gpio_configuration.h"

void
gpio_initialisation
(
    void
)
{
  CyU3PReturnStatus_t       apiRetStatus;
  CyU3PGpioClock_t          gpioClock;

  /* Init the GPIO module */
  gpioClock.fastClkDiv = 2;
  gpioClock.slowClkDiv = 2;
  gpioClock.simpleDiv  = CY_U3P_GPIO_SIMPLE_DIV_BY_2;
  gpioClock.clkSrc     = CY_U3P_SYS_CLK;
  gpioClock.halfDiv    = 0;

  /* Initialize Gpio interface */
  apiRetStatus = CyU3PGpioInit (&gpioClock, NULL);
  if (apiRetStatus != 0)
  {
    errorPrint("GPIO Init failed, Error Code = %d", apiRetStatus);
      CyFxAppErrorHandler (apiRetStatus);
  }
  else
    informationPrint("GPIO Init successful!");
}

void
gpio_ctrl_overwrite
(
    uint8_t gpio, uint8_t value, uint8_t directionIn
)
{
  CyU3PReturnStatus_t       apiRetStatus;
  CyU3PGpioSimpleConfig_t   gpioConfig;

  /* CTL pins are restricted and cannot be configured using I/O matrix configuration function,
   * must use GpioOverride to configure it */
  apiRetStatus = CyU3PDeviceGpioOverride (gpio, CyTrue);
  if (apiRetStatus != 0)
  {
    errorPrint("GPIO %d Override failed, Error Code = %d", gpio, apiRetStatus);
      CyFxAppErrorHandler (apiRetStatus);
  }
  else
    informationPrint("GPIO %d Override successful",gpio);

  /* SENSOR_RESET_GPIO is the Sensor reset pin */
  gpioConfig.outValue    = value;

  if (value == 1)
    gpioConfig.driveLowEn  = 0;
  else
    gpioConfig.driveLowEn  = 1;

  gpioConfig.driveHighEn = value;
  gpioConfig.inputEn     = directionIn;
  gpioConfig.intrMode    = CY_U3P_GPIO_NO_INTR;
  apiRetStatus           = CyU3PGpioSetSimpleConfig (gpio, &gpioConfig);

  if (apiRetStatus != CY_U3P_SUCCESS)
  {
    errorPrint("GPIO %d Set Config Error, Error Code = %d", gpio, apiRetStatus);
      CyFxAppErrorHandler (apiRetStatus);
  }
  else
    if (directionIn == 1)
      informationPrint("GPIO %d set configuration as input pin successful", gpio);
    else
      if (value == 1)
        informationPrint("GPIO %d set configuration as high output pin successful", gpio);
      else
        informationPrint("GPIO %d set configuration as low output pin successful", gpio);
}

void
gpio_configuration
(
    void
)
{
  gpio_initialisation();

  gpio_ctrl_overwrite(HARDWARE_GPIO_CPU1_CTRL5, 1, 0);
  gpio_ctrl_overwrite(HARDWARE_GPIO_CPU1_CTRL0, 1, 0);

}
