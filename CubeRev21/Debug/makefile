################################################################################
# Automatically-generated file. Do not edit!
################################################################################

-include ../makefile.init

RM := rm -rf

# All of the sources participating in the build are defined here
-include sources.mk
-include Drivers/STM32F7xx_HAL_Driver/Src/subdir.mk
-include Core/Startup/subdir.mk
-include Core/Src/subdir.mk
-include subdir.mk
-include objects.mk

ifneq ($(MAKECMDGOALS),clean)
ifneq ($(strip $(C_DEPS)),)
-include $(C_DEPS)
endif
endif

-include ../makefile.defs

# Add inputs and outputs from these tool invocations to the build variables 
EXECUTABLES += \
CubeRev21.elf \

SIZE_OUTPUT += \
default.size.stdout \

OBJDUMP_LIST += \
CubeRev21.list \

OBJCOPY_BIN += \
CubeRev21.bin \


# All Target
all: CubeRev21.elf secondary-outputs

# Tool invocations
CubeRev21.elf: $(OBJS) $(USER_OBJS) D:\HERMESS_SPSoftware\MicroController\CubeRev21\STM32F779BITX_FLASH.ld
	arm-none-eabi-gcc -o "CubeRev21.elf" @"objects.list" $(USER_OBJS) $(LIBS) -mcpu=cortex-m7 -T"D:\HERMESS_SPSoftware\MicroController\CubeRev21\STM32F779BITX_FLASH.ld" --specs=nosys.specs -Wl,-Map="CubeRev21.map" -Wl,--gc-sections -static --specs=nano.specs -mfpu=fpv5-d16 -mfloat-abi=hard -mthumb -Wl,--start-group -lc -lm -Wl,--end-group
	@echo 'Finished building target: $@'
	@echo ' '

default.size.stdout: $(EXECUTABLES)
	arm-none-eabi-size  $(EXECUTABLES)
	@echo 'Finished building: $@'
	@echo ' '

CubeRev21.list: $(EXECUTABLES)
	arm-none-eabi-objdump -h -S $(EXECUTABLES) > "CubeRev21.list"
	@echo 'Finished building: $@'
	@echo ' '

CubeRev21.bin: $(EXECUTABLES)
	arm-none-eabi-objcopy  -O binary $(EXECUTABLES) "CubeRev21.bin"
	@echo 'Finished building: $@'
	@echo ' '

# Other Targets
clean:
	-$(RM) *
	-@echo ' '

secondary-outputs: $(SIZE_OUTPUT) $(OBJDUMP_LIST) $(OBJCOPY_BIN)

.PHONY: all clean dependents
.SECONDARY:

-include ../makefile.targets
