/**
 * HERMESS SPU hardware configuration
 * based on the auto generated sb_hw_platform.h
 */

#ifndef HW_PLATFORM_H
#define HW_PLATFORM_H


/*-----------------------------------------------------------------------------
* GPIO PORTS
*---------------------------------------------------------------------------*/
#define PIN_RXSM_LO                     MSS_GPIO_0
#define PIN_RXSM_SOE                    MSS_GPIO_1
#define PIN_RXSM_SODS                   MSS_GPIO_2
#define PIN_ADC_START                   MSS_GPIO_3
#define PIN_SYNC_START                  MSS_GPIO_5
#define LED_RECORDING                   MSS_GPIO_30
#define LED_HEARTBEAT                   MSS_GPIO_31


/*-----------------------------------------------------------------------------
* APB SLAVES
*---------------------------------------------------------------------------*/
#define ADDR_STAMP_0                    0x50000000U
#define ADDR_STAMP_1                    0x50001000U
#define ADDR_STAMP_2                    0x50002000U
#define ADDR_STAMP_3                    0x50003000U
#define ADDR_STAMP_4                    0x50004000U
#define ADDR_STAMP_5                    0x50005000U


/*-----------------------------------------------------------------------------
* F2M Interrupts (MSS_INT_F2M[x])
*---------------------------------------------------------------------------*/
#define F2M_INT_STAMP_0                 0
#define F2M_INT_STAMP_1                 1
#define F2M_INT_STAMP_2                 2
#define F2M_INT_STAMP_3                 3
#define F2M_INT_STAMP_4                 4
#define F2M_INT_STAMP_5                 5


#endif
