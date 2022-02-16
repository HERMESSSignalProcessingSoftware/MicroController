/*
 * status.h
 *
 *  Created on: 28.12.2021
 *      Author: RG
 */

#ifndef STATUS_H_
#define STATUS_H_


/**
 * @file status.h
 * Enables the use of the global status register used for inter process
 * communication checked in the main loop
 */

#ifdef __cplusplus
extern "C" {
#endif


#include <stdint.h>

#define MSS_SIGNAL_SPI_WRITE        (1 << 0)
#define MSS_SIGNAL_TELEMETRY        (1 << 1)
#define MSS_SIGNAL_UPDATE_META      (1 << 2)
/*Living indicator*/
#define TIM2_HEARTBEAT_SIGNAL       (1 << 3)
#define SIGNAL_TM_GAP               (1 << 4)
/*RXSM signals
 * do not change shifting, it will be ored with  the status reg of the synchronizer
 * */
#define MSS_SIGNAL_SODS             (1 << 27)
#define MSS_SIGNAL_SOE              (1 << 26)
#define MSS_SIGNAL_LO               (1 << 29)

#define MSS_SIGNAL_SODS_RESET       (1 << 7)
#define MSS_SIGNAL_SOE_RESET        (1 << 8)
#define MSS_SIGNAL_LO_RESET         (1 << 9)
/*DAPI signals */
#define MSS_SIGNAL_DAPI_CMD         (1 << 15)
#define MSS_MEMORY_ERASE            (1 << 16)

#define MSS_SIGNAL_WRITE_AND_KILL   (1 << 20)
/* Telemetry signals */
#define TX_Finish_Signal            (1 << 21)
#define RX_Receive_Signal           (1 << 22)
#define TX_ResetMSSTelemetryBuffer  (1 << 23)

/**
 * A variable to signal system states from ISR to main loop
 */
extern uint32_t mssSignals;

#ifdef __cplusplus
}
#endif


#endif /* STATUS_H_ */
