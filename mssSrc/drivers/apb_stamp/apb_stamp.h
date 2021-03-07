/**
 * @mainpage HERMESS APB STAMP driver
 *
 * @section intro_sec Introduction
 * This driver implements the interface for communicating with the HERMESS
 * custom FPGA component "STAMP". The STAMP connects to in total three
 * TI ADS114X, whereas two measure the strain gauge rosettes and one measures
 * the temperature of a single STAMP.
 *
 * @section setup_sec Setup
 * 1. Initialize GPIO connected to ADC start with high
 * 2. Create a callback function which will be called by the interrupt
 *      service routine, when new measurements are available. Make
 *      sure to keep it short. Name the function
 *      "void FabricIrq<N>_IRQHandler ();"
 *      and replace <N> with the appropriate interrupt pin number.
 * 3. Create an empty apb_stamp_t
 * 4. Call APB_STAMP_init
 * 5. Call APB_STAMP_writeADC to configure the ADCs
 * 6. Call APB_STAMP_writeADC and APB_STAMP_readAdc to verify configuration
 * 7. Enable the the interrupts
 * 7. Pull the ADCs start signal low
 * 8. Enable Continuous mode via configuration command
 * 10. Enable the continuous signal
 *
 * @section mod_sec Address modifiers
 * There are three modifiers that can be passed to functions accessing the
 * APB component. All of them can be asserted simultaneously with use of
 * bitwise or.
 * 1. STAMP_MOD_ATOMIC: An atomic operation does not permit STAMP component
 *      to read another value in continuous mode from the ADCs, even when
 *      the ADC signals that there are new data available. Furthermore when
 *      asserting this modifier, it will keep the chip select in its state
 *      even after finishing the write.
 *      Also note, that it is important to not assert this
 *      modifier on the last call of functions accessing this STAMP, as it
 *      will practically freeze the component until it finishes the next
 *      transaction.
 * 2. STAMP_MOD_STATUS_RESET: This resets the internal status register
 *      of the STAMP component. These are only the informations as stored in
 *      struct stamp_status. It does not reset the component. This modifier
 *      is useful when reading the status register, as it will only be reset
 *      after it has been read.
 * 3. STAMP_MOD_DATA_READY: This modifier is only allowed when writing to
 *      the ADCs directly and must not be used with any other function than
 *      APB_STAMP_writeAdc. This will prevent the microcontroller from
 *      continuing before the ADCs confirmed finishing their activity by
 *      pulling the DRDY signal low.
 *
 * @section cont_sec Continuous mode
 * STAMP components. If it is enabled, the STAMP
 * module will automatically read all incoming transmissions from the ADCs
 * and stores them in internal registers. Once both DMS sent their values,
 * the interrupt is triggered and the MCU can process the data.
 *
 * @section sync_sec Synchronization
 * It is important to keep all ADCs reading the strain gauges in sync. For
 * that purpose the HDL components implement their own synchronization logic
 * that is mostly outside the accessibility of this driver. The only way
 * to disable this feature by software is by pulling the GPIO driving
 * the "request_resync" pin low. Manual ADC resynchronization can be achieved
 * by toggling the ADC start pin low for a few cycles.
 */

#ifndef APB_STAMP_H
#define APB_STAMP_H

#ifdef __cplusplus
extern "C" {
#endif


#include <stdint.h>
#include "../../hal/hal.h"


// always usable address modifier
#define STAMP_MOD_NONE              0x00U
#define STAMP_MOD_ATOMIC            0x80U
#define STAMP_MOD_STATUS_RESET      0x40U
// address modifier only for use with writeAdc
#define STAMP_MOD_DATA_READY        0x08U


// usable addresses
#define STAMP_REG_NOP               0x00U
#define STAMP_REG_WRITE_DMS1        0x01U
#define STAMP_REG_WRITE_DMS2        0x02U
#define STAMP_REG_WRITE_TEMP        0x04U
#define STAMP_REG_READ_SPI_IN       0x08U
#define STAMP_REG_READ_DMS12        0x10U
#define STAMP_REG_READ_TMPSR        0x18U
#define STAMP_REG_CONF              0x20U
#define STAMP_REG_DUMMY             0x38U


/**
 * ANY MANUAL CHANGES TO INSTANCES OF THIS STRUCT LEAD TO UNDEFINED BEHAVIOR!
 */
typedef struct apb_stamp {
    uint32_t baseAddr;
    uint8_t interruptPin;
} apb_stamp_t;


/**
 * Use this union to evaluate the status bits
 * Make sure to generate using "stamp_status_t name = {0}"
 */
typedef struct stamp_status {
    // indicates, if the ADC read a new value since last acquisition
    uint8_t dms1NewVal : 1;
    uint8_t dms2NewVal : 1;
    uint8_t tempNewVal : 1;
    // indicates, if a an ADC reading was overwritten, since the last acquisition
    uint8_t dms1OverwrittenVal : 1;
    uint8_t dms2OverwrittenVal : 1;
    uint8_t tempOverwrittenVal : 1;
    // indicates, if this stamp component currently requests a resync
    uint8_t requestResync : 1;
    // the number of clock cycles one dms adc was ahead of the other one
    uint8_t asyncCycles : 6;
    // the generic HDL identifier of this component
    uint8_t stampId : 3;
} stamp_status_t;
uint32_t APB_STAMP_generateStatusBitfield (stamp_status_t *status);
void APB_STAMP_generateStatusStruct (uint32_t bits, stamp_status_t *status);


/**
 * Use this union to generate and evaluate the configuration register
 * Make sure to generate using "stamp_config_t name = {0}"
 */
typedef struct stamp_config {
    // setting this bit will reset the stamp module (not adcs)
    uint8_t reset : 1;
    // enable/disable continuous mode
    uint8_t continuous : 1;
    // the number of (HDL prescaled) clock cycles between two dms data
    // acquisitions, before a resync is requested by the component
    // to the synchronizer unit
    uint8_t asyncThreshold : 6;
    // just a dummy to fill word
    uint32_t empty : 21;
    // a unique id for better recognition of stored data, that are included
    // into the status register
    uint8_t stampId : 3;
} stamp_config_t;
uint32_t APB_STAMP_generateConfigBitfield (stamp_config_t* conf);
void APB_STAMP_generateConfigStruct (uint32_t bits, stamp_config_t* config);


/**
 * Initializes a STAMP driver instance.
 *
 * @param instance
 * an empty, non null pointer to an apb_stamp_t instance
 *
 * @param baseAddr
 * the APB base address
 *
 * @param interruptPin
 * the integer of the F2M integer register bit. Must be 0 <= n <= 15.
 */
void APB_STAMP_init (
        apb_stamp_t *instance,
        addr_t baseAddr,
        uint8_t interruptPin
);


/**
 * Writes to the configuration register of the STAMP component. This
 * does not configure the ADCs.
 *
 * @param instance
 * An initialized apb_stamp_t instance pointer.
 *
 * @param conf
 * A pointer to a stamp_config_t instance to be programmed into the component.
 *
 * @param mod
 * One or more of STAMP_MOD_NONE, STAMP_MOD_ATOMIC and STAMP_MOD_STATUS_RESET.
 * Can be combined using bitwise or.
 */
void APB_STAMP_writeConfig (
        apb_stamp_t *instance,
        stamp_config_t *conf,
        uint8_t mod
);


/**
 * Reads the configuration register of the STAMP component.
 *
 * @param instance
 * An initialized apb_stamp_t instance pointer.
 *
 * @param conf
 * A pointer to a stamp_config_t instance to be filled by the component.
 *
 * @param mod
 * One or more of STAMP_MOD_NONE, STAMP_MOD_ATOMIC and STAMP_MOD_STATUS_RESET.
 * Can be combined using bitwise or.
 */
void APB_STAMP_readConfig (
        apb_stamp_t *instance,
        stamp_config_t *conf,
        uint8_t mod
);


/**
 * Write commands to the ADCs
 *
 * @param instance
 * An initialized apb_stamp_t instance pointer.
 *
 * @param adcs
 * One or more of STAMP_REG_WRITE_DMS1, STAMP_REG_WRITE_DMS2
 * and STAMP_REG_WRITE_TEMP. Can be combined using bitwise or. If writing
 * to one or more ADCs at a time you should make sure the triggered commands
 * do not write to their respective outputs. Failing to do so could potentially
 * damage the ADCs.
 *
 * @param val
 * the value to pass via SPI to the controller. Note, that the SPI
 * module always transfers 16 bit regardless of the operation. If sending
 * a command with only 8 bits it is recommended to fill the higher 8 bits with
 * an ADC NOP command.
 *
 * @param mod
 * One or more of STAMP_MOD_NONE, STAMP_MOD_ATOMIC, STAMP_MOD_STATUS_RESET and
 * STAMP_MOD_DATA_READY. Can be combined using bitwise or.
 */
void APB_STAMP_writeAdc (
        apb_stamp_t *instance,
        uint8_t adcs,
        uint16_t val,
        uint8_t mod
);


/**
 * Returns the last SPI output made by an ADC. This function does not
 * initiate a new communication with the ADC, it merely outputs the previously
 * recorded data.
 *
 * @param instance
 * An initialized apb_stamp_t instance pointer.
 *
 * @param mod
 * One or more of STAMP_MOD_NONE, STAMP_MOD_ATOMIC and STAMP_MOD_STATUS_RESET.
 * Can be combined using bitwise or.
 *
 * @return The ADC out of the last two sent commands. Most significant byte
 * is the first transaction, least significant byte is second transaction.
 */
uint16_t APB_STAMP_readAdc (apb_stamp_t *instance, uint8_t mod);


/**
 * This returns the measurements of the strain gauges (DMS1 and DMS2) after
 * they have been acquired during continuous mode. They should be read during
 * handling the interrupt triggered by this component.
 *
 * @param instance
 * An initialized apb_stamp_t instance pointer.
 *
 * @param mod
 * One or more of STAMP_MOD_NONE, STAMP_MOD_ATOMIC and STAMP_MOD_STATUS_RESET.
 * Can be combined using bitwise or.
 *
 * @return Most significant 16 bits are for DMS1. The other ones are for DMS2.
 * Both values are signed.
 */
uint32_t APB_STAMP_readDms12 (apb_stamp_t *instance, uint8_t mod);


/**
 * This returns the measurements of the temperature sensor and the status
 * register after it has been acquired during continuous mode. They
 * should be read during handling the interrupt triggered by this component.
 *
 * @param instance
 * An initialized apb_stamp_t instance pointer.
 *
 * @param mod
 * One or more of STAMP_MOD_NONE, STAMP_MOD_ATOMIC and STAMP_MOD_STATUS_RESET.
 * Can be combined using bitwise or.
 *
 * @return Most significant 16 bits are for temperature sensor and are signed.
 * The other ones are for the status register and can be evaluated using
 * stamp_status_t.
 */
uint32_t APB_STAMP_readTempStatusRegister (apb_stamp_t *instance, uint8_t mod);


/**
 * Enables the interrupt service routine for the associated pin. The ISR is
 * defined as "void FabricIrq<N>_IRQHandler ()" and must be implemented
 * by user. To prevent multiple interrupts from the same event, call
 * APB_STAMP_clearInterrupt first during the ISR.
 *
 * The Fabric Interface Interrupt Controller (FIIC) only allows
 * F2M interrupts to be active high and require fabric user logic to
 * keep the interrupt line asserted until it was cleared. Therefore do not
 * reset the STAMP components register before clearing the MSS interrupt bit.
 *
 * @param instance
 * An initialized apb_stamp_t instance pointer.
 */
void APB_STAMP_enableInterrupt (apb_stamp_t *instance);


/**
 * Disables the interrupt service routine for the associated pin.
 *
 * @param instance
 * An initialized apb_stamp_t instance pointer.
 */
void APB_STAMP_disableInterrupt (apb_stamp_t *instance);


/**
 * Clears the interrupt flag and should be called at the beginning
 * of an ISR.
 *
 * @param interruptPin
 * The interruptPin as it was defined for APB_STAMP_init
 */
void APB_STAMP_clearInterrupt (uint8_t interruptPin);


/**
 * The dummy register is not connected to any logic other than
 * storing 32 bits of data. Just used for debugging.
 *
 * @param instance
 * An initialized apb_stamp_t instance pointer.
 *
 * @param val
 * The value to write to the register.
 *
 * @param mod
 * One or more of STAMP_MOD_NONE, STAMP_MOD_ATOMIC and STAMP_MOD_STATUS_RESET.
 * Can be combined using bitwise or.
 */
void APB_STAMP_writeDummy (
        apb_stamp_t *instance,
        uint32_t val,
        uint8_t mod
);


/**
 * Reads the dummy register.
 *
 * @param instance
 * An initialized apb_stamp_t instance pointer.
 *
 * @param mod
 * One or more of STAMP_MOD_NONE, STAMP_MOD_ATOMIC and STAMP_MOD_STATUS_RESET.
 * Can be combined using bitwise or.
 *
 * @return The register value.
 */
uint32_t APB_STAMP_readDummy (apb_stamp_t *instance, uint8_t mod);



#ifdef __cplusplus
}
#endif

#endif
