/*
 * Test.h
 *
 *  Created on: 16.01.2021
 *      Author: Robin Grimsmann
 */

#ifndef INC_TEST_H_
#define INC_TEST_H_

#include "cypress.h"

/**
 * Performes a fast memory test, just writes one page and reads it
 * Defines the DUTS
 */
uint32_t FastMemoryTest(void);

/**
 * The actual test
 */
uint32_t FastTest(SPI_Values DUT);
/**
 * @brief: tests the memory
 * TEST: Write to memory, wait, read form memory.
 * @return 0: Passed.
 */
uint32_t MemoryTest(void);

/**
 * @retun: 1: passed
 */
uint32_t MemoryTestDUT(SPI_Values dut);

#endif /* INC_TEST_H_ */
