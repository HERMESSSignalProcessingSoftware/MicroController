/*
 * test.h
 *
 *  Created on: 09.06.2020
 *      Author: Robin Grimsmann
 */

#ifndef INC_TEST_H_
#define INC_TEST_H_

#include <stdlib.h>
#include "main.h"

/**
 * @brief Test of ADC
 * @return uint32_t 1: test ok
 */
uint32_t testADC(void);

/**
 * @brief Test of Memory
 * @return uint32_t 1: test ok
 */
uint32_t testMemory(void);

/**
 * @brief Test of DAPI
 * @return uint32_t 1: test ok
 */
uint32_t testDAPI(void);

/**
 * @brief Test of Telemetry
 * @return uint32_t 1: test ok
 */
uint32_t testTelemetry(void);

/**
 * @brief Test Main Function
 * @todo: uncomment your test line if you have implemented the tests in one of your source code files
 * @return 0: test failed
 */
uint32_t Test(void);

#endif /* INC_TEST_H_ */
