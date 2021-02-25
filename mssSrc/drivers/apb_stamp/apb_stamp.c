#ifdef __cplusplus
extern "C" {
#endif

#include "apb_stamp.h"
#include "../../CMSIS/m2sxxx.h"


// this mask allows to remove data ready address modifier, when
// it is not allowed to prevent undefined behavior
#define NO_DR_MASK 0xF7


static const IRQn_Type g_irqnLut[] = {
        FabricIrq0_IRQn,
        FabricIrq1_IRQn,
        FabricIrq2_IRQn,
        FabricIrq3_IRQn,
        FabricIrq4_IRQn,
        FabricIrq5_IRQn,
        FabricIrq6_IRQn,
        FabricIrq7_IRQn,
        FabricIrq8_IRQn,
        FabricIrq10_IRQn,
        FabricIrq11_IRQn,
        FabricIrq12_IRQn,
        FabricIrq13_IRQn,
        FabricIrq14_IRQn,
        FabricIrq15_IRQn
};


void APB_STAMP_init (
        apb_stamp_t *instance,
        addr_t baseAddr,
        uint8_t interruptPin
) {
    // save to instance for later reference
    instance->baseAddr = baseAddr;
    instance->interruptPin = interruptPin;

    // reset the entire component
    stamp_config_t conf = {0};
    conf.values.reset = 1;
    APB_STAMP_writeConfig(instance, &conf, STAMP_MOD_STATUS_RESET);

    // make sure the interrupt is disabled for the beginning
    APB_STAMP_disableInterrupt(instance);
}


void APB_STAMP_writeConfig (
        apb_stamp_t *instance,
        stamp_config_t *conf,
        uint8_t mod
) {
    addr_t addr = instance->baseAddr | STAMP_REG_CONF | (mod & NO_DR_MASK);
    HW_set_32bit_reg(addr, conf->bits);
}


void APB_STAMP_readConfig (
        apb_stamp_t *instance,
        stamp_config_t *conf,
        uint8_t mod
) {
    addr_t addr = instance->baseAddr | STAMP_REG_CONF | (mod & NO_DR_MASK);
    conf->bits = HW_get_32bit_reg(addr);
}


void APB_STAMP_writeAdc (
        apb_stamp_t *instance,
        uint8_t adcs,
        uint16_t val,
        uint8_t mod
) {
    HW_set_32bit_reg(instance->baseAddr | adcs | mod, val);
}


uint16_t APB_STAMP_readAdc (apb_stamp_t *instance, uint8_t mod) {
    addr_t addr = instance->baseAddr |
            STAMP_REG_READ_SPI_IN | (mod & NO_DR_MASK);
    return HW_get_32bit_reg(addr);
}


uint32_t APB_STAMP_readDms12 (apb_stamp_t *instance, uint8_t mod) {
    addr_t addr = instance->baseAddr | STAMP_REG_READ_DMS12 |
            (mod & NO_DR_MASK);
    return HW_get_32bit_reg(addr);
}


uint32_t APB_STAMP_readTempStatusRegister (apb_stamp_t *instance, uint8_t mod) {
    addr_t addr = instance->baseAddr |
            STAMP_REG_READ_TMPSR | (mod & NO_DR_MASK);
    return HW_get_32bit_reg(addr);
}


void APB_STAMP_enableInterrupt (apb_stamp_t *instance) {
    NVIC_EnableIRQ(g_irqnLut[instance->interruptPin]);
}


void APB_STAMP_disableInterrupt (apb_stamp_t *instance) {
    NVIC_DisableIRQ(g_irqnLut[instance->interruptPin]);
    NVIC_ClearPendingIRQ(g_irqnLut[instance->interruptPin]);
}


void APB_STAMP_clearInterrupt (uint8_t interruptPin) {
    NVIC_ClearPendingIRQ(g_irqnLut[interruptPin]);
}


void APB_STAMP_writeDummy (
        apb_stamp_t *instance,
        uint32_t val,
        uint8_t mod
) {
    addr_t addr = instance->baseAddr | STAMP_REG_DUMMY | (mod & NO_DR_MASK);
    HW_set_32bit_reg(addr, val);
}


uint32_t APB_STAMP_readDummy (apb_stamp_t *instance, uint8_t mod) {
    addr_t addr = instance->baseAddr | STAMP_REG_DUMMY | (mod & NO_DR_MASK);
    return HW_get_32bit_reg(addr);
}



#ifdef __cplusplus
}
#endif
