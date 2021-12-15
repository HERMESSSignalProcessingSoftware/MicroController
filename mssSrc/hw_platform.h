/**
 * @file hw_platform.h
 * HERMESS SPU hardware configuration
 * based on the auto generated sb_hw_platform.h
 */

#ifndef HW_PLATFORM_H
#define HW_PLATFORM_H


/*-----------------------------------------------------------------------------
* GPIO PORTS
*---------------------------------------------------------------------------*/
#define _GPIO_PORT(num)                 MSS_GPIO_##num
#define GPIO_PORT(num)                  _GPIO_PORT(num)
#define _GPIO_HANDLER(num)              GPIO##num##_IRQHandler
#define GPIO_HANDLER(num)               _GPIO_HANDLER(num)

#define IN_RXSM_LO                      0
#define IN_RXSM_SOE                     1
#define IN_RXSM_SODS                    2
#define OUT_ADC_START                   3
#define OUT_RESET_N                     4
#define IN_WP                           5
#define LED_RECORDING                   30
#define LED_HEARTBEAT                   31
/*Needed because of the nCS falling - rising behaviour after each byte */
#define FLASH_CS1                       28
#define FLASH_CS2                       29
#define OUT_ENABLE_MEM_SYNC             12

/*-----------------------------------------------------------------------------
* APB SLAVES
*---------------------------------------------------------------------------*/
#define ADDR_MEMORY                     0x50000000U
#define ADDR_STAMP_0                    0x50001000U
#define ADDR_STAMP_1                    0x50002000U
#define ADDR_STAMP_2                    0x50003000U
#define ADDR_STAMP_3                    0x50004000U
#define ADDR_STAMP_4                    0x50005000U
#define ADDR_STAMP_5                    0x50006000U


/*-----------------------------------------------------------------------------
* F2M INTERRUPTS (MSS_INT_F2M[x])
*---------------------------------------------------------------------------*/
#define F2M_INT_MEMORYSYNC              0
#define F2M_INT_STAMP_0                 1
#define F2M_INT_STAMP_1                 2
#define F2M_INT_STAMP_2                 3
#define F2M_INT_STAMP_3                 4
#define F2M_INT_STAMP_4                 5
#define F2M_INT_STAMP_5                 6

#define MEMORY_SYNC_IRQn                FabricIrq0_IRQn

#endif
