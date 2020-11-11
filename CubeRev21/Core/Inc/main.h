/* USER CODE BEGIN Header */
/**
  ******************************************************************************
  * @file           : main.h
  * @brief          : Header for main.c file.
  *                   This file contains the common defines of the application.
  ******************************************************************************
  * @attention
  *
  * <h2><center>&copy; Copyright (c) 2020 STMicroelectronics.
  * All rights reserved.</center></h2>
  *
  * This software component is licensed by ST under BSD 3-Clause license,
  * the "License"; You may not use this file except in compliance with the
  * License. You may obtain a copy of the License at:
  *                        opensource.org/licenses/BSD-3-Clause
  *
  ******************************************************************************
  */
/* USER CODE END Header */

/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __MAIN_H
#define __MAIN_H

#ifdef __cplusplus
extern "C" {
#endif

/* Includes ------------------------------------------------------------------*/
#include "stm32f7xx_hal.h"

/* Private includes ----------------------------------------------------------*/
/* USER CODE BEGIN Includes */

/* USER CODE END Includes */

/* Exported types ------------------------------------------------------------*/
/* USER CODE BEGIN ET */

/* USER CODE END ET */

/* Exported constants --------------------------------------------------------*/
/* USER CODE BEGIN EC */

/* USER CODE END EC */

/* Exported macro ------------------------------------------------------------*/
/* USER CODE BEGIN EM */

/* USER CODE END EM */

/* Exported functions prototypes ---------------------------------------------*/
void Error_Handler(void);

/* USER CODE BEGIN EFP */

/* USER CODE END EFP */

/* Private defines -----------------------------------------------------------*/
#define DAPI_RX_Pin GPIO_PIN_9
#define DAPI_RX_GPIO_Port GPIOI
#define LED_4_Pin GPIO_PIN_14
#define LED_4_GPIO_Port GPIOI
#define LED_3_Pin GPIO_PIN_3
#define LED_3_GPIO_Port GPIOF
#define LED_2_Pin GPIO_PIN_4
#define LED_2_GPIO_Port GPIOF
#define LED_1_Pin GPIO_PIN_5
#define LED_1_GPIO_Port GPIOF
#define SD_CS_Pin GPIO_PIN_10
#define SD_CS_GPIO_Port GPIOF
#define IO8_Pin GPIO_PIN_0
#define IO8_GPIO_Port GPIOC
#define IO7_Pin GPIO_PIN_1
#define IO7_GPIO_Port GPIOC
#define IO6_Pin GPIO_PIN_2
#define IO6_GPIO_Port GPIOC
#define IO5_Pin GPIO_PIN_3
#define IO5_GPIO_Port GPIOC
#define DAPI_TX_Pin GPIO_PIN_0
#define DAPI_TX_GPIO_Port GPIOA
#define IO4_Pin GPIO_PIN_3
#define IO4_GPIO_Port GPIOH
#define IO3_Pin GPIO_PIN_4
#define IO3_GPIO_Port GPIOH
#define IO2_Pin GPIO_PIN_5
#define IO2_GPIO_Port GPIOH
#define IO1_Pin GPIO_PIN_3
#define IO1_GPIO_Port GPIOA
#define nCS_DMS1_Pin GPIO_PIN_13
#define nCS_DMS1_GPIO_Port GPIOF
#define nCS_DMS2_Pin GPIO_PIN_14
#define nCS_DMS2_GPIO_Port GPIOF
#define nCS_DMS3_Pin GPIO_PIN_15
#define nCS_DMS3_GPIO_Port GPIOF
#define nCS_DMS4_Pin GPIO_PIN_0
#define nCS_DMS4_GPIO_Port GPIOG
#define nCS_DMS5_Pin GPIO_PIN_1
#define nCS_DMS5_GPIO_Port GPIOG
#define nCS_DMS7_Pin GPIO_PIN_7
#define nCS_DMS7_GPIO_Port GPIOE
#define FL1_HLD_Pin GPIO_PIN_9
#define FL1_HLD_GPIO_Port GPIOH
#define FL1_WP_Pin GPIO_PIN_10
#define FL1_WP_GPIO_Port GPIOH
#define FL1_RES_Pin GPIO_PIN_11
#define FL1_RES_GPIO_Port GPIOH
#define FL1_CS2_Pin GPIO_PIN_12
#define FL1_CS2_GPIO_Port GPIOH
#define FL1_CS1_Pin GPIO_PIN_12
#define FL1_CS1_GPIO_Port GPIOB
#define nCS_PT3_Pin GPIO_PIN_8
#define nCS_PT3_GPIO_Port GPIOD
#define FL2_HLD_Pin GPIO_PIN_9
#define FL2_HLD_GPIO_Port GPIOD
#define FL2_RES_Pin GPIO_PIN_10
#define FL2_RES_GPIO_Port GPIOD
#define FL2_CS2_Pin GPIO_PIN_11
#define FL2_CS2_GPIO_Port GPIOD
#define FL2_CS1_Pin GPIO_PIN_12
#define FL2_CS1_GPIO_Port GPIOD
#define FL2_WP_Pin GPIO_PIN_13
#define FL2_WP_GPIO_Port GPIOD
#define nCS_PT2_Pin GPIO_PIN_14
#define nCS_PT2_GPIO_Port GPIOD
#define nCS_PT1_Pin GPIO_PIN_15
#define nCS_PT1_GPIO_Port GPIOD
#define MS_SEL_Pin GPIO_PIN_2
#define MS_SEL_GPIO_Port GPIOG
#define nDRDY_DMS1_Pin GPIO_PIN_4
#define nDRDY_DMS1_GPIO_Port GPIOG
#define nDRDY_DMS1_EXTI_IRQn EXTI4_IRQn
#define nDRDY_DMS2_Pin GPIO_PIN_8
#define nDRDY_DMS2_GPIO_Port GPIOA
#define nDRDY_DMS2_EXTI_IRQn EXTI9_5_IRQn
#define nDRDY_DMS3_Pin GPIO_PIN_9
#define nDRDY_DMS3_GPIO_Port GPIOA
#define nDRDY_DMS3_EXTI_IRQn EXTI9_5_IRQn
#define nDRDY_DMS4_Pin GPIO_PIN_10
#define nDRDY_DMS4_GPIO_Port GPIOA
#define nDRDY_DMS4_EXTI_IRQn EXTI15_10_IRQn
#define nDRDY_DMS5_Pin GPIO_PIN_11
#define nDRDY_DMS5_GPIO_Port GPIOA
#define nDRDY_DMS5_EXTI_IRQn EXTI15_10_IRQn
#define nDRDY_DMS6_Pin GPIO_PIN_12
#define nDRDY_DMS6_GPIO_Port GPIOA
#define nDRDY_DMS6_EXTI_IRQn EXTI15_10_IRQn
#define INTERSPU_TX_Pin GPIO_PIN_12
#define INTERSPU_TX_GPIO_Port GPIOC
#define INTERSPU_RX_Pin GPIO_PIN_2
#define INTERSPU_RX_GPIO_Port GPIOD
#define nDRDY_PT3_Pin GPIO_PIN_13
#define nDRDY_PT3_GPIO_Port GPIOJ
#define nDRDY_PT3_EXTI_IRQn EXTI15_10_IRQn
#define nDRDY_PT2_Pin GPIO_PIN_14
#define nDRDY_PT2_GPIO_Port GPIOJ
#define nDRDY_PT2_EXTI_IRQn EXTI15_10_IRQn
#define nDRDY_PT1_Pin GPIO_PIN_15
#define nDRDY_PT1_GPIO_Port GPIOJ
#define nDRDY_PT1_EXTI_IRQn EXTI15_10_IRQn
#define EXP_IN_Pin GPIO_PIN_0
#define EXP_IN_GPIO_Port GPIOE
#define EXP_OUT_Pin GPIO_PIN_1
#define EXP_OUT_GPIO_Port GPIOE
#define SODS_OPT_Pin GPIO_PIN_5
#define SODS_OPT_GPIO_Port GPIOI
#define SODS_OPT_EXTI_IRQn EXTI9_5_IRQn
#define SOE_OPT_Pin GPIO_PIN_6
#define SOE_OPT_GPIO_Port GPIOI
#define SOE_OPT_EXTI_IRQn EXTI9_5_IRQn
#define LO_OPT_Pin GPIO_PIN_7
#define LO_OPT_GPIO_Port GPIOI
#define LO_OPT_EXTI_IRQn EXTI9_5_IRQn
/* USER CODE BEGIN Private defines */

/* USER CODE END Private defines */

#ifdef __cplusplus
}
#endif

#endif /* __MAIN_H */

/************************ (C) COPYRIGHT STMicroelectronics *****END OF FILE****/
