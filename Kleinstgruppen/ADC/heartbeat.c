#include "main.h"
#include "cmsis_os2.h"

void heartbeat(void *arg) {
	osThreadSetPriority(osThreadGetId(), osPriorityLow);

	while (1) {
		HAL_GPIO_TogglePin(GPIOB, GPIO_PIN_14); //rote Led
		HAL_Delay(250);

	}

}
