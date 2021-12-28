#ifndef TOOLS_H
#define TOOLS_H

#ifdef __cplusplus
extern "C" {
#endif



#include <stdint.h>
#include "../status.h"
#include "../../drivers/apb_memory/memory.h"

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

/**
 * Create Timer2 as heartbeat timer
 * @param delay in ms to be counted down
 */
void InitHeartbeat(uint32_t delay);
/**
 * Stops timer 2
 * disabels interrupt
 */
void StopHeartbeat(void);

/**
 *
 * @param ptr
 * @param value
 * @param size
 */
void ResetBuffer(uint8_t *ptr, uint32_t value, uint32_t size);

/**
 * Tests the Metaaddress update algorithm
 *
 * @param dev SPI_Value the device to be used as meta data storage
 * @return 0 if ok, > 0 for each error in 64 values written
 */
uint32_t TestMetaWriter(SPI_Values dev);

#ifdef __cplusplus
}
#endif

#endif
