/**
 * @mainpage HERMESS storage component
 *
 * @section intro_sec Introduction
 * !!!
 *
 * @section use_sec Usage
 * !!!
 *
 * @section hw_sec Hardware requirements
 * !!!
 */

#ifndef STORGAGE_H
#define STORGAGE_H


#ifdef __cplusplus
extern "C" {
#endif

#include "../drivers/apb_memory/MemorySyncAPB.h"
#include "../sb_hw_platform.h"
#include "../drivers/mss_spi/mss_spi.h"
#include "../drivers/apb_memory/memory.h"

void EraseMemory(void);

#ifdef __cplusplus
}
#endif


#endif
