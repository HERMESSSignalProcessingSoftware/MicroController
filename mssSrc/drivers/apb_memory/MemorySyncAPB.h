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

#define Stamp1ShadowReg1        0x004
#define Stamp1ShadowReg2        0x008
#define Stamp2ShadowReg1        0x00c
#define Stamp2ShadowReg2        0x010
#define Stamp3ShadowReg1        0x014
#define Stamp3ShadowReg2        0x018
#define Stamp4ShadowReg1        0x01c
#define Stamp4ShadowReg2        0x020
#define Stamp5ShadowReg1        0x024
#define Stamp5ShadowReg2        0x028
#define Stamp6ShadowReg1        0x02c
#define Stamp6ShadowReg2        0x030
#define SynchStatusReg          0x034
#define ConfigReg               0x038
#define ResetTimerValueReg      0x03c
#define WaitingTimerValueReg    0x040
#define ResyncTimerValueReg     0x044
#define TimeStampReg            0x048
#define SynchStatusReg2         0x04c

#define LOWESTADDR               Stamp1ShadowReg1
#define LOWESTSTAMP              Stamp1ShadowReg1
#define HIGHESTSTAMP             Stamp6ShadowReg2
#define HIGHSTADDR               SynchStatusReg2
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


#define PENDING_SYNCHRONIZER_INTERRUPT  (1 << 31)
#define PENDING_READ_INTERRUPT          (1 << 30)
#define LO_MARKER                       (1 << 29)
#define PENDING_APB_ADDRESS_ERROR       (1 << 28)

#define SODS_MARKER                     (1 << 27)
#define SOE_MARKER                      (1 << 26)
// SynchStatusReg
//    --     31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9  8  7  6  5  4  3  2  1  0
//    --  +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//    --  |PS|PR|LO|AE|SD|SE|O6|O5|O4|O3|O2|O1|RE|RE|RE|RE|RE|RE|RE|RE|R6|R5|R4|R3|R2|R1|M6|M5|M4|M3|M2|M1|
//    --  +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//    -- M1 - M6: Bitmask for every stamp which has not provied a newAvails signal
//    -- R1 - R6: Bitmask for every stamp which is requesting a Resync
//    -- RE: 8 bit counter: the number of ResyncEvents
//    -- O1 - O6: StatusReg2 overflow marker. Means that the difference to the timestamp register is bigger than the size of 5 bits
//    -- AE: APB Error Address not known
//    -- U: Unused
//    -- PR: Pending Reading Interrupt
//    -- PS: Pending Synchronizer Interrupt
//    -- Timer and Prescaler
//

// signal SynchStatusReg2          : std_logic_vector(31 downto 0);
//    --     31 30 29 28 27 26 25 24 23 22 21 20 19 18 17 16 15 14 13 12 11 10 9  8  7  6  5  4  3  2  1  0
//    --  +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//    --  |U |U |S6|S6|S6|S6|S6|S5|S5|S5|S5|S5|S4|S4|S4|S4|S4|S3|S3|S3|S3|S3|S2|S2|S2|S2|S2|S1|S1|S1|S1|S1|
//    --  +--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+
//    -- U: Unused
//    -- S1 5 bit counter; relative distance to the Timestamp value

#define MARKER_ERASE_DONE   (1 << 31)

#ifdef __cplusplus
}
#endif


#endif /* DRIVERS_APB_MEMORY_MEMORYSYNCAPB_H_ */
