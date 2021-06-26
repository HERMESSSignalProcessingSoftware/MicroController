/*
 * HERMESS.h
 *
 *  Created on: 26.06.2021
 *      Author: Robin Grimsmann
 */

#ifndef COMPONENTS_HERMESS_H_
#define COMPONENTS_HERMESS_H_

#ifdef __cplusplus
extern "C" {
#endif



#include <stdint.h>

#define MSS_SIGNAL_SPI_WRITE     (1 << 0)
#define MSS_SIGNAL_TELEMETRY     (1 << 1)
#define MSS_SIGNAL_UPDATE_META   (1 << 2)
#define TIM2_HEARTBEAT_SIGNAL    (1 << 3)
#define MSS_SIGNAL_SODS          (1 << 4)
#define MSS_SIGNAL_SOE           (1 << 5)
#define MSS_SIGNAL_LO            (1 << 6)

#define MSS_SIGNAL_WRITE_AND_KILL (1 << 7)
/*
 * A variable to signal system states form ISR to main loop
 */
extern uint32_t MSS_SIGNALS;

#ifdef __cplusplus
}
#endif



#endif /* COMPONENTS_HERMESS_H_ */
