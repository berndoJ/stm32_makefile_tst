# ------------------------------------------------------------------------------
# MAIN MAKEFILE
# ------------------------------------------------------------------------------
# PROJECT: stm32tctst
# TARGET PLATFORM: STM32F103x6
# TARGET CPU: ARM Cortex-M3
# ------------------------------------------------------------------------------

include ./project.mk

LIBDIR = ./lib

LIB_STM32F1HAL_DIR = $(LIBDIR)/stm32f1hal
#LIB_CMSIS_CORE_DIR = $(LIBDIR)/cmsiscore
#LIB_CMSIS_STM32F1XX_DIR = $(LIBDIR)/cmsisstm32f1xx
MODULE_CORE_DIR = ./core

.PHONY: all
all: lib_stm32f1hal module_core __cplt

.PHONY: lib_stm32f1hal
lib_stm32f1hal:
	@echo "$(C_LPURPLE)[Make] Making library stm32f1hal.$(C_CLR)"
	@cd $(LIB_STM32F1HAL_DIR) && $(MAKE) lib_stm32f1hal -s
	@echo "[Make] Library stm32f1hal built."

.PHONY: module_core
module_core: lib_stm32f1hal
	@echo "$(C_LPURPLE)[Make] Making module core.$(C_CLR)"
	@cd $(MODULE_CORE_DIR) && $(MAKE) module_core -s
	@echo "$(C_LPURPLE)[Make] Module core built.$(C_CLR)"

.PHONY: clean
clean:
	@echo "$(C_LPURPLE)[Make] Cleaning up library stm32f1hal...$(C_CLR)"
	@cd $(LIB_STM32F1HAL_DIR) && $(MAKE) clean -s
	@echo "$(C_LPURPLE)[Make] Cleaning up module core...$(C_CLR)"
	@cd $(MODULE_CORE_DIR) && $(MAKE) clean -s
	@echo "$(C_LPURPLE)[Make] Cleaned up.$(C_CLR)"

.PHONY: rebuild
rebuild: clean all

.PHONY: __cplt
__cplt:
	@echo "------------------"
	@echo "  $(C_GREEN)BUILD COMPLETE$(C_CLR)  "
	@echo "------------------"


