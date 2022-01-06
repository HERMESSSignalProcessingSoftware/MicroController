#ifndef sb_HW_PLATFORM_H_
#define sb_HW_PLATFORM_H_
/*****************************************************************************
*
*Created by Microsemi SmartDesign  Tue Dec 28 12:59:59 2021
*
*Memory map specification for peripherals in sb
*/


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
#define LED_HEARTBEAT_MEMSYNC           25
#define LED_FPGA_LOADED                 26
#define LED_RECORDING                   30
#define LED_HEARTBEAT                   31
/*Needed because of the nCS falling - rising behaviour after each byte */
#define FLASH_CS1                       28
#define FLASH_CS2                       29
#define OUT_ENABLE_MEM_SYNC             12


/*-----------------------------------------------------------------------------
* CM3 subsystem memory map
* Initiator(s) for this subsystem: CM3 
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



#endif /* sb_HW_PLATFORM_H_*/
