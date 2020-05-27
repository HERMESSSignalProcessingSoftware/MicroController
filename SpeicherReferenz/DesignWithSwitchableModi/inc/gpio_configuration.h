#ifndef _INCLUDED_GPIO_CONFIGURATION_H_
#define _INCLUDED_GPIO_CONFIGURATION_H_

#define HARDWARE_GPIO_CPU1_CTRL0    17
#define HARDWARE_GPIO_CPU1_CTRL5    22

void
gpio_initialisation
(
    void
);

void
gpio_ctrl_overwrite
(
    uint8_t gpio, uint8_t value, uint8_t directionIn
);

void
gpio_configuration
(
    void
);

#endif
