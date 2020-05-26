################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
X:/wtj/FacetVision/embedded_software/branch/DesignWithSwitchableModi/src/I2C_Sensorsbasics_.c \
X:/wtj/FacetVision/embedded_software/branch/DesignWithSwitchableModi/src/TCA9546A.c \
X:/wtj/FacetVision/embedded_software/branch/DesignWithSwitchableModi/src/camera_ptzcontrol.c \
X:/wtj/FacetVision/embedded_software/branch/DesignWithSwitchableModi/src/criticalErrorHandler.c \
X:/wtj/FacetVision/embedded_software/branch/DesignWithSwitchableModi/src/cyfxuvcdscr.c \
X:/wtj/FacetVision/embedded_software/branch/DesignWithSwitchableModi/src/fpga_communication.c \
X:/wtj/FacetVision/embedded_software/branch/DesignWithSwitchableModi/src/gpio_configuration.c \
X:/wtj/FacetVision/embedded_software/branch/DesignWithSwitchableModi/src/sensor_sonyIMX214.c \
X:/wtj/FacetVision/embedded_software/branch/DesignWithSwitchableModi/src/uvc.c 

OBJS += \
./SRC/I2C_Sensorsbasics_.o \
./SRC/TCA9546A.o \
./SRC/camera_ptzcontrol.o \
./SRC/criticalErrorHandler.o \
./SRC/cyfxuvcdscr.o \
./SRC/fpga_communication.o \
./SRC/gpio_configuration.o \
./SRC/sensor_sonyIMX214.o \
./SRC/uvc.o 

C_DEPS += \
./SRC/I2C_Sensorsbasics_.d \
./SRC/TCA9546A.d \
./SRC/camera_ptzcontrol.d \
./SRC/criticalErrorHandler.d \
./SRC/cyfxuvcdscr.d \
./SRC/fpga_communication.d \
./SRC/gpio_configuration.d \
./SRC/sensor_sonyIMX214.d \
./SRC/uvc.d 


# Each subdirectory must supply rules for building sources it contributes
SRC/I2C_Sensorsbasics_.o: X:/wtj/FacetVision/embedded_software/branch/DesignWithSwitchableModi/src/I2C_Sensorsbasics_.c
	@echo 'Building file: $<'
	@echo 'Invoking: Cross ARM C Compiler'
	arm-none-eabi-gcc -mcpu=arm926ej-s -marm -mthumb-interwork -O3 -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -Wall  -g -D__CYU3P_TX__=1 -I"C:\Program Files (x86)\Cypress\EZ-USB FX3 SDK\1.3\/fw_lib/1_3_3/inc" -std=gnu11 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

SRC/TCA9546A.o: X:/wtj/FacetVision/embedded_software/branch/DesignWithSwitchableModi/src/TCA9546A.c
	@echo 'Building file: $<'
	@echo 'Invoking: Cross ARM C Compiler'
	arm-none-eabi-gcc -mcpu=arm926ej-s -marm -mthumb-interwork -O3 -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -Wall  -g -D__CYU3P_TX__=1 -I"C:\Program Files (x86)\Cypress\EZ-USB FX3 SDK\1.3\/fw_lib/1_3_3/inc" -std=gnu11 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

SRC/camera_ptzcontrol.o: X:/wtj/FacetVision/embedded_software/branch/DesignWithSwitchableModi/src/camera_ptzcontrol.c
	@echo 'Building file: $<'
	@echo 'Invoking: Cross ARM C Compiler'
	arm-none-eabi-gcc -mcpu=arm926ej-s -marm -mthumb-interwork -O3 -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -Wall  -g -D__CYU3P_TX__=1 -I"C:\Program Files (x86)\Cypress\EZ-USB FX3 SDK\1.3\/fw_lib/1_3_3/inc" -std=gnu11 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

SRC/criticalErrorHandler.o: X:/wtj/FacetVision/embedded_software/branch/DesignWithSwitchableModi/src/criticalErrorHandler.c
	@echo 'Building file: $<'
	@echo 'Invoking: Cross ARM C Compiler'
	arm-none-eabi-gcc -mcpu=arm926ej-s -marm -mthumb-interwork -O3 -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -Wall  -g -D__CYU3P_TX__=1 -I"C:\Program Files (x86)\Cypress\EZ-USB FX3 SDK\1.3\/fw_lib/1_3_3/inc" -std=gnu11 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

SRC/cyfxuvcdscr.o: X:/wtj/FacetVision/embedded_software/branch/DesignWithSwitchableModi/src/cyfxuvcdscr.c
	@echo 'Building file: $<'
	@echo 'Invoking: Cross ARM C Compiler'
	arm-none-eabi-gcc -mcpu=arm926ej-s -marm -mthumb-interwork -O3 -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -Wall  -g -D__CYU3P_TX__=1 -I"C:\Program Files (x86)\Cypress\EZ-USB FX3 SDK\1.3\/fw_lib/1_3_3/inc" -std=gnu11 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

SRC/fpga_communication.o: X:/wtj/FacetVision/embedded_software/branch/DesignWithSwitchableModi/src/fpga_communication.c
	@echo 'Building file: $<'
	@echo 'Invoking: Cross ARM C Compiler'
	arm-none-eabi-gcc -mcpu=arm926ej-s -marm -mthumb-interwork -O3 -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -Wall  -g -D__CYU3P_TX__=1 -I"C:\Program Files (x86)\Cypress\EZ-USB FX3 SDK\1.3\/fw_lib/1_3_3/inc" -std=gnu11 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

SRC/gpio_configuration.o: X:/wtj/FacetVision/embedded_software/branch/DesignWithSwitchableModi/src/gpio_configuration.c
	@echo 'Building file: $<'
	@echo 'Invoking: Cross ARM C Compiler'
	arm-none-eabi-gcc -mcpu=arm926ej-s -marm -mthumb-interwork -O3 -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -Wall  -g -D__CYU3P_TX__=1 -I"C:\Program Files (x86)\Cypress\EZ-USB FX3 SDK\1.3\/fw_lib/1_3_3/inc" -std=gnu11 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

SRC/sensor_sonyIMX214.o: X:/wtj/FacetVision/embedded_software/branch/DesignWithSwitchableModi/src/sensor_sonyIMX214.c
	@echo 'Building file: $<'
	@echo 'Invoking: Cross ARM C Compiler'
	arm-none-eabi-gcc -mcpu=arm926ej-s -marm -mthumb-interwork -O3 -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -Wall  -g -D__CYU3P_TX__=1 -I"C:\Program Files (x86)\Cypress\EZ-USB FX3 SDK\1.3\/fw_lib/1_3_3/inc" -std=gnu11 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

SRC/uvc.o: X:/wtj/FacetVision/embedded_software/branch/DesignWithSwitchableModi/src/uvc.c
	@echo 'Building file: $<'
	@echo 'Invoking: Cross ARM C Compiler'
	arm-none-eabi-gcc -mcpu=arm926ej-s -marm -mthumb-interwork -O3 -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -Wall  -g -D__CYU3P_TX__=1 -I"C:\Program Files (x86)\Cypress\EZ-USB FX3 SDK\1.3\/fw_lib/1_3_3/inc" -std=gnu11 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


