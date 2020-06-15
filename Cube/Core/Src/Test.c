/*
 * Test.c
 *
 *  Created on: 09.06.2020
 *      Author: Robin Grimsmann
 */

#include "test.h"
#include "main.h"
#include <assert.h>

uint32_t Test(void) {
	uint32_t b = 1;
/* ADC
	b &= testADC();
	assert(b == 1);
*/
/* Memory
	b &= testMemory();
	assert(b == 1);
*/
/* DAPI
	b &= testDAPI();
	assert(b == 1);
*/
	b &= testTelemetry();
	/*TODO: Was macht assert auf dem MCU*/
	assert(b == 1);
	return b;
}
