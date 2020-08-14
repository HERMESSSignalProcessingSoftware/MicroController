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
*/
/* Memory
	b &= testMemory();
*/
/* DAPI
	b &= testDAPI();
*/
	b &= testTelemetry();
	/*TODO: Was macht assert auf dem MCU*/
	return b;
}
