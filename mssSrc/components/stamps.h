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


#define STAMPS_PGA_1        0
#define STAMPS_PGA_2        1
#define STAMPS_PGA_4        2
#define STAMPS_PGA_8        3
#define STAMPS_PGA_16       4
#define STAMPS_PGA_32       5
#define STAMPS_PGA_64       6
#define STAMPS_PGA_128      7

#define STAMPS_SPS_5        0
#define STAMPS_SPS_10       1
#define STAMPS_SPS_20       2
#define STAMPS_SPS_40       3
#define STAMPS_SPS_80       4
#define STAMPS_SPS_160      5
#define STAMPS_SPS_320      6
#define STAMPS_SPS_640      7
#define STAMPS_SPS_1000     8
#define STAMPS_SPS_2000     9


typedef enum cal_type {
    OFFSET_CAL,
    GAIN_CAL
} cal_type_t;
typedef enum adc_type {
    ADC_SGR,
    ADC_RTD
} adc_type_t;


/**
 * This function initializes all six STAMPS with a ready-to-go configuration
 * - configure all ADCs including PGA and samplerate
 * - enables continuous reading
 * - synchronizes ADCs
 *
 * @note does not enable enable any STAMP interrupts
 *
 * @param pgaSgr
 * The programmable gain amplification value for the strain
 * gauge rosettes using the appropriate STAMPS_PGA_x constants
 *
 * @param spsSgr
 * The samplerate of for the strain gauge rosettes using the
 * appropriate STAMPS_SPS_x constants
 *
 * @param pgaRtd
 * The programmable gain amplification value for the resistive temperature
 * detectors using the appropriate STAMPS_PGA_x constants
 *
 * @param spsSgr
 * The samplerate of for the resistive temperature detectors using the
 * appropriate STAMPS_SPS_x constants
 */
void stampsInit (uint8_t pgaSgr, uint8_t spsSgr,
        uint8_t pgaRtd, uint8_t spsRtd);


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


// !!! not implemented yet
void stampsTriggerCal (cal_type_t cal, adc_type_t adcType);
void stampsWriteCal (cal_type_t cal, adc_type_t adcType, uint32_t values[]);
void stampsReadCal (cal_type_t cal, adc_type_t adcType, uint32_t buffer[]);



#ifdef __cplusplus
}
#endif

#endif
