/**
 * @mainpage HERMESS DAPI component
 *
 * @section intro_sec Introduction
 * !!!
 *
 * @section use_sec Usage
 * !!! Check Github DAPI spec
 *
 * @section hw_sec Hardware requirements
 * !!! UART0
 */

#ifndef DAPI_H
#define DAPI_H


#ifdef __cplusplus
extern "C" {
#endif


/**
 * Initializes the DAPI using these settings on UART
 * - Baudrate 115200
 * - 8 Data Bits
 * - No polarity bit
 * - One stop bit
 * - Little endianness
 */
void dapiInit (void);


/**
 * execute the pending command, if one is pending
 */
void dapiExecutePendingCommand (void);



#ifdef __cplusplus
}
#endif


#endif
