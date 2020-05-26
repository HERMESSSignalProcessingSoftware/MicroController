/*
 * Callbacks.c
 *
 *  Created on: 26.05.2020
 *      Author: Robin Grimsmann
 */


void HAL_SPI_TxCpltCallback(SPI_HandleTypeDef *hspi)
{
    tmpCounterTx++;
    volatile uint8_t x = 5;
}

void HAL_SPI_RxCpltCallback(SPI_HandleTypeDef *hspi)
{
    tmpCounterRx++;
    volatile uint8_t y = 5;
}
