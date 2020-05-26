################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
X:/wtj/FacetVision/embedded_software/branch/DesignWithSwitchableModi/src/FX3FW/cyfxtx.c 

S_UPPER_SRCS += \
X:/wtj/FacetVision/embedded_software/branch/DesignWithSwitchableModi/src/FX3FW/cyfx_gcc_startup.S 

OBJS += \
./SRC/FX3FW/cyfx_gcc_startup.o \
./SRC/FX3FW/cyfxtx.o 

C_DEPS += \
./SRC/FX3FW/cyfxtx.d 

S_UPPER_DEPS += \
./SRC/FX3FW/cyfx_gcc_startup.d 


# Each subdirectory must supply rules for building sources it contributes
SRC/FX3FW/cyfx_gcc_startup.o: X:/wtj/FacetVision/embedded_software/branch/DesignWithSwitchableModi/src/FX3FW/cyfx_gcc_startup.S
	@echo 'Building file: $<'
	@echo 'Invoking: Cross ARM GNU Assembler'
	arm-none-eabi-gcc -mcpu=arm926ej-s -marm -mthumb-interwork -O3 -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -Wall  -g -x assembler-with-cpp -I"C:\Program Files (x86)\Cypress\EZ-USB FX3 SDK\1.3\/fw_lib/1_3_3/inc" -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

SRC/FX3FW/cyfxtx.o: X:/wtj/FacetVision/embedded_software/branch/DesignWithSwitchableModi/src/FX3FW/cyfxtx.c
	@echo 'Building file: $<'
	@echo 'Invoking: Cross ARM C Compiler'
	arm-none-eabi-gcc -mcpu=arm926ej-s -marm -mthumb-interwork -O3 -fmessage-length=0 -fsigned-char -ffunction-sections -fdata-sections -Wall  -g -D__CYU3P_TX__=1 -I"C:\Program Files (x86)\Cypress\EZ-USB FX3 SDK\1.3\/fw_lib/1_3_3/inc" -std=gnu11 -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" -c -o "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '


