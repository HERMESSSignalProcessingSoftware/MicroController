#ifndef TOOLS_H
#define TOOLS_H

#ifdef __cplusplus
extern "C" {
#endif



#include <stdint.h>
#include "../../components/HERMESS.h"

/**
 * Wait for at least the specified time in milliseconds. This function
 * introduces some overhead however and therefore waits longer than
 * the specified time. Also note, that other interrupts may significantly
 * impact the actual delay time.
 *
 * This function uses Timer0 and requires it to not be used by other functions.
 * This includes the 64 bit timer, which will not be usable simultaneously.
 *
 * @param ms
 * the time to wait in milliseconds
 */
void delay (uint32_t ms);


/**
 * !!! Currently only logs to DAPI. This is not the intended future behavior.
 *
 * @param message
 * Null-terminated ASCII string
 */
void spuLog (char message[]);

/*
 * @param period: the value to present the heartbeat signal by setting MSS_Signals |= TIM1_HEARTBEAT_SIGNAL
 *
 */
void SetHeartbeatPeriode(uint32_t periode);

#ifdef __cplusplus
}
#endif

#endif
