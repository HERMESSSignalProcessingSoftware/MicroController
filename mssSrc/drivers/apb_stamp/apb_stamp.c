#ifdef __cplusplus
extern "C" {
#endif

#include "apb_stamp.h"
#include "../../CMSIS/m2sxxx.h"


// this mask allows to remove data ready address modifier, when
// it is not allowed to prevent undefined behavior
#define NO_DR_MASK 0xF7U


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


uint32_t APB_STAMP_generateStatusBitfield (stamp_status_t *status) {
    return ((uint32_t) status->dms1NewVal << 15) |
            ((uint32_t) status->dms2NewVal << 14) |
            ((uint32_t) status->tempNewVal << 13) |
            ((uint32_t) status->dms1OverwrittenVal << 12) |
            ((uint32_t) status->dms2OverwrittenVal << 11) |
            ((uint32_t) status->tempOverwrittenVal << 10) |
            ((uint32_t) status->requestResync << 9) |
            ((uint32_t) status->asyncCycles << 3) |
            (uint32_t) status->stampId;
}
void APB_STAMP_generateStatusStruct (uint32_t bits, stamp_status_t *status) {
    status->dms1NewVal = (bits >> 15) & 0x1U;
    status->dms2NewVal = (bits >> 14) & 0x1U;
    status->tempNewVal = (bits >> 13) & 0x1U;
    status->dms1OverwrittenVal = (bits >> 12) & 0x1U;
    status->dms2OverwrittenVal = (bits >> 11) & 0x1U;
    status->tempOverwrittenVal = (bits >> 10) & 0x1U;
    status->requestResync = (bits >> 9) & 0x1U;
    status->asyncCycles = (bits >> 3) & 0x3FU;
    status->stampId = bits & 0x7U;
}

uint32_t APB_STAMP_generateConfigBitfield (stamp_config_t* conf) {
    return ((uint32_t) conf->reset << 31) |
            ((uint32_t) conf->continuous << 30) |
            ((uint32_t) conf->asyncThreshold << 24) |
            ((uint32_t) conf->empty << 3) |
            (uint32_t) conf->stampId;
}
void APB_STAMP_generateConfigStruct (uint32_t bits, stamp_config_t* config) {
    config->reset = (bits >> 31) & 0x1U;
    config->continuous = (bits >> 30) & 0x1U;
    config->asyncThreshold = (bits >> 24) & 0x3FU;
    config->empty = (bits >> 3) & 0x1FFFFFU;
    config->stampId = bits & 0x7U;
}


apb_stamp_t APB_STAMP_init (
        addr_t baseAddr,
        uint8_t interruptPin
) {
    apb_stamp_t instance = {0};

    // save to instance for later reference
    instance.baseAddr = baseAddr;
    instance.interruptPin = interruptPin;

    // reset the entire component
    stamp_config_t conf = {.reset = 1};
    APB_STAMP_writeConfig(&instance, &conf, STAMP_MOD_STATUS_RESET);

    // make sure the interrupt is disabled for the beginning
    APB_STAMP_disableInterrupt(&instance);

    return instance;
}


void APB_STAMP_writeConfig (
        apb_stamp_t *instance,
        stamp_config_t *conf,
        uint16_t mod
) {
    addr_t addr = instance->baseAddr | STAMP_REG_CONF | (mod & NO_DR_MASK);
    HW_set_32bit_reg(addr, APB_STAMP_generateConfigBitfield(conf));
}


void APB_STAMP_readConfig (
        apb_stamp_t *instance,
        stamp_config_t *conf,
        uint16_t mod
) {
    addr_t addr = instance->baseAddr | STAMP_REG_CONF | (mod & NO_DR_MASK);
    APB_STAMP_generateConfigStruct(HW_get_32bit_reg(addr), conf);
}


void APB_STAMP_writeAdc (
        apb_stamp_t *instance,
        uint8_t adcs,
        uint16_t val,
        uint16_t mod
) {
    HW_set_32bit_reg(instance->baseAddr | adcs | mod, val);
}


uint16_t APB_STAMP_readAdc (apb_stamp_t *instance, uint16_t mod) {
    addr_t addr = instance->baseAddr |
            STAMP_REG_READ_SPI_IN | (mod & NO_DR_MASK);
    return HW_get_32bit_reg(addr);
}


uint32_t APB_STAMP_readDms12 (apb_stamp_t *instance, uint16_t mod) {
    addr_t addr = instance->baseAddr | STAMP_REG_READ_DMS12 |
            (mod & NO_DR_MASK);
    return HW_get_32bit_reg(addr);
}


uint32_t APB_STAMP_readTempStatusRegister (apb_stamp_t *instance, uint16_t mod) {
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
        uint16_t mod
) {
    addr_t addr = instance->baseAddr | STAMP_REG_DUMMY | (mod & NO_DR_MASK);
    HW_set_32bit_reg(addr, val);
}


uint32_t APB_STAMP_readDummy (apb_stamp_t *instance, uint16_t mod) {
    addr_t addr = instance->baseAddr | STAMP_REG_DUMMY | (mod & NO_DR_MASK);
    return HW_get_32bit_reg(addr);
}



#ifdef __cplusplus
}
#endif
