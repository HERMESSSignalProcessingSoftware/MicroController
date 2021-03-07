/**
 * @mainpage HERMESS STAMPS component
 *
 * @section intro_sec Introduction
 * !!!
 *
 * @section use_sec Usage
 * !!! Interrupts, init, using calibration data
 *
 * @section hw_sec Hardware requirements
 * !!! Timer1, GPIOs, APB STAMPS
 */

#ifndef STAMPS_H
#define STAMPS_H

#ifdef __cplusplus
extern "C" {
#endif



#include <stdint.h>


typedef enum cal_type {
    OFFSET_CAL,
    GAIN_CAL
} cal_type_t;
typedef enum adc_type {
    ADC_DMS,
    ADC_TEMP
} adc_type_t;


/**
 * This function initializes all six STAMPS with a ready-to-go configuration
 * - configure all ADCs including PGA and samplerate
 * - enables continuous reading
 * - synchronizes ADCs
 * - enables both interrupt types (data ready and async event)
 */
void stampsInit (void);


/**
 * Synchronizes all ADCs again by pulling the start pin low and waiting for
 * a millisecond
 */
void stampsSync (void);


/**
 * Enables the interrupts caused by new data availability on processor level.
 * This requires the HDL STAMP components and the ADCs to be in continuous mode.
 */
void stampsEnableDReadyInterrupts (void);
/**
 * Disables the interrupts caused by new data availability on processor level.
 * The HDL STAMP components and ADCs will still trigger their interrupts.
 */
void stampsDisableDReadyInterrupts (void);
/**
 * Sets the callback function for a data ready event.
 *
 * @param callback
 * Pass a null pointer (0), if no further action shall be taken. Otherwise
 * pass a function pointer to a function accepting 3 values
 *      1. The identifier of the STAMP (0-7)
 *      2. The measurement values of DMS 1 and 2. Two concatenated
 *         signed 16 bit values.
 *      3. The measurement value of the temperature sensor (16 bits) and the
 *         status register (16 bits).
 */
void stampsSetDReadyCallback (void (*callback)(uint8_t, uint32_t, uint32_t));


/**
 * Enables the interrupt caused by an async event detected by the synchronizer
 * HDL component on microcontroller level.
 */
void stampsEnableAsyncInterrupt (void);
/**
 * Disables the interrupt caused by an async event detected by the synchronizer
 * HDL component on microcontroller level.
 */
void stampsEnableAsyncInterrupt (void);
/**
 * Sets a user defined callback for the interrupt in case of an async event,
 * that will be called by the actual ISR.
 *
 * @param callback
 * A null pointer (0) in case no function shall be called. Otherwise a function
 * pointer accepting no arguments and returning no value.
 */
void stampsSetAyncCallback (void (*callback)());


void stampsTriggerCal (cal_type_t cal, adc_type_t adcType);
void stampsWriteCal (cal_type_t cal, adc_type_t adcType, uint32_t values[]);
void stampsReadCal (cal_type_t cal, adc_type_t adcType, uint32_t buffer[]);



#ifdef __cplusplus
}
#endif

#endif
