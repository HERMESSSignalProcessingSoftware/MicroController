/*
 * MemorySyncAPB.h
 *
 *  Created on: 24.06.2021
 *      Author: Robin Grimsmann
 */

#ifndef DRIVERS_APB_MEMORY_MEMORYSYNCAPB_H_
#define DRIVERS_APB_MEMORY_MEMORYSYNCAPB_H_


#ifdef __cplusplus
extern "C" {
#endif

#define Stamp1ShadowReg1        0x4
#define Stamp1ShadowReg2        0x8
#define Stamp2ShadowReg1        0xc
#define Stamp2ShadowReg2        0x10
#define Stamp3ShadowReg1        0x14
#define Stamp3ShadowReg2        0x18
#define Stamp4ShadowReg1        0x1c
#define Stamp4ShadowReg2        0x20
#define Stamp5ShadowReg1        0x24
#define Stamp5ShadowReg2        0x28
#define Stamp6ShadowReg1        0x2c
#define Stamp6ShadowReg2        0x30
#define SynchStatusReg          0x34
#define ConfigReg               0x38
#define ResetTimerValueReg      0x3c
#define WaitingTimerValueReg    0x40
#define ResyncTimerValueReg     0x44
#define TimeStampReg            0x48
#define SynchStatusReg2         0x4c

//CONFIG REG
//     31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9  8  7  6  5  4  3  2  1  0
//  +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//  |EI|CS|CR|U |U |U |U |U |U |U |U |U |U |U |U |U |U |U |U |U |U |U |U |U |U |2 |2 |2 |U |1 |1 |1 |
//  +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
// 1. Number of minimal neccessary newAvail Signals default: 4
// 2. Number of Request Resync signals, below this number: Dont care
//                                      above this number: Run Resync Event
// EI: Enable Interrupts
// CS: Clear SynchronizerInterrupt
// CR: Clear Read Interrupt
// U - Unused

#define CONFIG_REG_ENABLE_INTERRUPT     (1 << 31)
#define CONFIG_REG_CLEAR_SYNC_INTERRUPT (1 << 30)
#define CONFIG_REG_CLEAR_READ_INTERRUPT (1 << 29)

/**
 * @param number, the number to be programmed in ConfigReg starting a bit 0 to bit 3 therefore all other, higher values will be cut of
 */
#define CONFIG_REG_NUMBER_OF_NEW_AVAILABLES(number) (number  & 0x00000003)

/*
 * @param number, the number to be programmed in ConfigReg starting at bit 4 to 6, all numbers greater than 2**3 -1 will be cut of
 */
#define CONFIG_REG_NUMBER_OF_REQUEST_RESNYCS(number) ((number & 0x00000003)  << 4)




#ifdef __cplusplus
}
#endif


#endif /* DRIVERS_APB_MEMORY_MEMORYSYNCAPB_H_ */
