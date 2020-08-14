/**
 * @brief: SPUConfig.h saves the spu configuration
 * @authro:  R. Grimsmann
 *
 *
 */
#ifndef __SPU_CONFIG_H__
#define __SPU_CONFIG_H__

#include "main.h"

/**
 * defines logical values of bool to 0 (False) and 1 (True)
 * ERR will only be returned by functions!
 */
typedef enum {FALSE = 0, TRUE, ERR} Bool_t;

typedef enum {SODS, SOE, LO} Signal_t;

/*MACROS*/
/**
 * Returns the index in [0:10] from an given GPIO Pin block
 */
#define LOOKUP_PINBLOCK_INDEX(i) ((uint32_t)i & 0x0000FFFF) >> 10

/**
 * Look Up Pin index by counting leading zeros using ARM clz instruction
 */
#define LOOKUP_PIN_INDEX(i) (31 - __builtin_clz(i))

#define NUMBER_OF_PINBLOCKS 11
#define NUMBER_OF_PINS 16
#define ADCBITMAPNORMAL 0xFFFFFFFF
#define ADCBITMAPDMS 	0xFFFFFFC0
/*Lookup table*/
//extern uint8_t ADCLookup[NUMBER_OF_PINBLOCKS][NUMBER_OF_PINS];
extern uint8_t ADCLookup[NUMBER_OF_PINS];
/* ADC bit map */
extern uint32_t ADCBitMap;

/**
 * Stores any information about the SPU in one typedef struct Config_t
 * We may need to provid more information about the SPU, for the software
 * core its enough to know whether it runs as secondary or not
 */
typedef struct {
	Bool_t secondary;
	Bool_t LO;
	Bool_t SODS;
	Bool_t SOE;
	uint32_t seconday_status; // will be filled by primary SPU after secondary SPU answers
} Config_t;

/**
 * Set the signal in the local config struct
 */
void SetSignal(Signal_t signal);

/**
 * Clears the signal in the local config struct
 */
void ClearSignal(Signal_t signal);

/**
 * Toggles the signal
 */
void Toggle(Signal_t signal);

/**
 * Returns the value of the signals
 * @return the values of the 3 signals, LO at bit 0,  SODS at bit 1 and SOE at bit 2
 */
uint32_t GetSignals(void);

/**
 * Returns a specific signal
 * @return Bool_t TRUE if signal is set
 */
Bool_t GetSignal(Signal_t signal);


/**
 * SPURun
 * @brief contains the main loop of the application interrupted by EXTI (DMS)
 *
 * @param Config_t *config
 * @return none
 */
void SPURun(Config_t *config);

#endif
