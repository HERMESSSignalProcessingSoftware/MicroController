################################################################################
# Automatically-generated file. Do not edit!
################################################################################

-include ../makefile.init

RM := rm -rf

# All of the sources participating in the build are defined here
-include sources.mk
-include Startup/subdir.mk
-include Src/subdir.mk
-include Drivers/STM32F7xx_HAL_Driver/Src/subdir.mk
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
F746StampTest.elf \

SIZE_OUTPUT += \
default.size.stdout \

OBJDUMP_LIST += \
F746StampTest.list \

OBJCOPY_BIN += \
F746StampTest.bin \


# All Target
all: F746StampTest.elf secondary-outputs

# Tool invocations
F746StampTest.elf: $(OBJS) $(USER_OBJS) D:\HERMESS_SPSoftware\MicroController\STAMPTest\F746StampTest\STM32F746ZGTX_FLASH.ld
	arm-none-eabi-gcc -o "F746StampTest.elf" @"objects.list" $(USER_OBJS) $(LIBS) -mcpu=cortex-m7 -T"D:\HERMESS_SPSoftware\MicroController\STAMPTest\F746StampTest\STM32F746ZGTX_FLASH.ld" --specs=nosys.specs -Wl,-Map="F746StampTest.map" -Wl,--gc-sections -static --specs=nano.specs -mfpu=fpv5-sp-d16 -mfloat-abi=hard -mthumb -Wl,--start-group -lc -lm -Wl,--end-group
	@echo 'Finished building target: $@'
	@echo ' '

default.size.stdout: $(EXECUTABLES)
	arm-none-eabi-size  $(EXECUTABLES)
	@echo 'Finished building: $@'
	@echo ' '

F746StampTest.list: $(EXECUTABLES)
	arm-none-eabi-objdump -h -S $(EXECUTABLES) > "F746StampTest.list"
	@echo 'Finished building: $@'
	@echo ' '

F746StampTest.bin: $(EXECUTABLES)
	arm-none-eabi-objcopy  -O binary $(EXECUTABLES) "F746StampTest.bin"
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
