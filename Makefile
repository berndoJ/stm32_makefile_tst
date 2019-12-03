# ------------------------------------------------------------------------------
# MAIN MAKEFILE
# ------------------------------------------------------------------------------
# PROJECT: stm32tctst
# TARGET PLATFORM: STM32F103x6
# TARGET CPU: ARM Cortex-M3
# ------------------------------------------------------------------------------

include ./project.mk

LIBDIR = ./lib
FLASHDIR = ./flash

LINKERSCRIPT = ./flash/STM32F103X6_FLASH.ld

LIB_STM32F1HAL_DIR = $(LIBDIR)/stm32f1hal
MODULE_CORE_DIR = ./core

SLIBDIRS  = -L $(LIB_STM32F1HAL_DIR)/bin
SLIBDIRS += -L $(MODULE_CORE_DIR)/bin

SLIBS  = -lmodcore
SLIBS += -lstm32f1hal
SLIBS += -lc
SLIBS += -lm
SLIBS += -lnosys

.PHONY: build
build: buildinfo flashimg_elf flashimg_hex flashimg_bin flashimg_size __cplt

.PHONY: buildinfo
buildinfo:
	@echo "$(C_BOLD)-------------------------------------------"
	@echo "Building $(PROJECTNAME)..."
	@echo "Version $(VERSION_MAJOR).$(VERSION_MINOR)"
	@echo "$(COPYRIGHT)"
	@echo "-------------------------------------------$(C_CLR)"

.PHONY: flashimg_elf
flashimg_elf: lib_stm32f1hal module_core | $(FLASHDIR)
	@echo "$(C_LBLUE)[Make] Linking source code...$(C_CLR)"
	@$(LD) $(LDFLAGS) $(SLIBDIRS) $(SLIBS) -static -Wl,-Map=$(FLASHDIR)/$(PROJECTNAME).map,--cref -o $(FLASHDIR)/$(PROJECTNAME).elf
	@echo "$(C_LBLUE)[Make] Source code linked successfully.$(C_CLR)"
	@echo "$(C_LGREEN)[Make] Created ELF flash image.$(C_CLR)"

.PHONY: flashimg_hex
flashimg_hex: flashimg_elf | $(FLASHDIR)
	@echo "[Make] Converting ELF to HEX flash image..."
	@$(OBJCP) -O ihex $(FLASHDIR)/$(PROJECTNAME).elf $(FLASHDIR)/$(PROJECTNAME).hex
	@echo "$(C_LGREEN)[Make] Created HEX flash image.$(C_CLR)"

.PHONY: flashimg_bin
flashimg_bin: flashimg_elf | $(FLASHDIR)
	@echo "[Make] Converting ELF to BIN flash image..."
	@$(OBJCP) -O binary -S $(FLASHDIR)/$(PROJECTNAME).elf $(FLASHDIR)/$(PROJECTNAME).bin
	@echo "$(C_LGREEN)[Make] Created BIN flash image.$(C_CLR)"

.PHONY: flashimg_size
flashimg_size:
	@echo ""
	@echo "$(C_ORANGE)[Make] Flash size parametrics:"
	@$(CSIZE) $(FLASHDIR)/$(PROJECTNAME).elf
	@echo "$(C_CLR)"

.PHONY: lib_stm32f1hal
lib_stm32f1hal:
	@echo "$(C_LPURPLE)[Make] Building library stm32f1hal.$(C_CLR)"
	@cd $(LIB_STM32F1HAL_DIR) && $(MAKE) lib_stm32f1hal -s
	@echo "[Make] Library stm32f1hal built."

.PHONY: module_core
module_core: lib_stm32f1hal
	@echo "$(C_LPURPLE)[Make] Building module core.$(C_CLR)"
	@cd $(MODULE_CORE_DIR) && $(MAKE) module_core -s
	@echo "$(C_LPURPLE)[Make] Module core built.$(C_CLR)"

.PHONY: clean
clean:
	@echo "$(C_LRED)[Make] Cleaning up library stm32f1hal...$(C_CLR)"
	@cd $(LIB_STM32F1HAL_DIR) && $(MAKE) clean -s
	@echo "$(C_LRED)[Make] Cleaning up module core...$(C_CLR)"
	@cd $(MODULE_CORE_DIR) && $(MAKE) clean -s
	@echo "$(C_LRED)[Make] Cleaned up.$(C_CLR)"

.PHONY: rebuild
rebuild: buildinfo clean build

$(FLASHDIR):
	@echo "[Make] Creating flash output folder."
	@mkdir -p $(FLASHDIR)

.PHONY: __cplt
__cplt:
	@echo "------------------"
	@echo "  $(C_LGREEN)BUILD COMPLETE$(C_CLR)  "
	@echo "------------------"

