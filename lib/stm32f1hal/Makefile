# Makefile for STM32F1 HAL library.
# Copyright (c) 2019 by Johannes Berndorfer

include ../../project.mk

LIBNAME = lib_stm32f1hal
LIBOUTFILE = libstm32f1hal.a
BINDIR = ./bin
SRCDIR = ./src

CSRC  = stm32f1xx_hal.c
CSRC += stm32f1xx_hal_can.c
CSRC += stm32f1xx_hal_adc.c
CSRC += stm32f1xx_hal_adc_ex.c
CSRC += stm32f1xx_hal_can.c
CSRC += stm32f1xx_hal_cec.c
CSRC += stm32f1xx_hal_cortex.c
CSRC += stm32f1xx_hal_crc.c
CSRC += stm32f1xx_hal_dac.c
CSRC += stm32f1xx_hal_dac_ex.c
CSRC += stm32f1xx_hal_dma.c
CSRC += stm32f1xx_hal_eth.c
CSRC += stm32f1xx_hal_exti.c
CSRC += stm32f1xx_hal_flash.c
CSRC += stm32f1xx_hal_flash_ex.c
CSRC += stm32f1xx_hal_gpio.c
CSRC += stm32f1xx_hal_gpio_ex.c
CSRC += stm32f1xx_hal_hcd.c
CSRC += stm32f1xx_hal_i2c.c
CSRC += stm32f1xx_hal_i2s.c
CSRC += stm32f1xx_hal_irda.c
CSRC += stm32f1xx_hal_iwdg.c
CSRC += stm32f1xx_hal_mmc.c
CSRC += stm32f1xx_hal_msp_template.c
CSRC += stm32f1xx_hal_nand.c
CSRC += stm32f1xx_hal_nor.c
CSRC += stm32f1xx_hal_pccard.c
CSRC += stm32f1xx_hal_pcd.c
CSRC += stm32f1xx_hal_pcd_ex.c
CSRC += stm32f1xx_hal_pwr.c
CSRC += stm32f1xx_hal_rcc.c
CSRC += stm32f1xx_hal_rcc_ex.c
CSRC += stm32f1xx_hal_rtc.c
CSRC += stm32f1xx_hal_rtc_ex.c
CSRC += stm32f1xx_hal_sd.c
CSRC += stm32f1xx_hal_smartcard.c
CSRC += stm32f1xx_hal_spi.c
CSRC += stm32f1xx_hal_sram.c
CSRC += stm32f1xx_hal_tim.c
CSRC += stm32f1xx_hal_timebase_rtc_alarm_template.c
CSRC += stm32f1xx_hal_timebase_tim_template.c
CSRC += stm32f1xx_hal_tim_ex.c
CSRC += stm32f1xx_hal_uart.c
CSRC += stm32f1xx_hal_usart.c
CSRC += stm32f1xx_hal_wwdg.c
CSRC += stm32f1xx_ll_adc.c
CSRC += stm32f1xx_ll_crc.c
CSRC += stm32f1xx_ll_dac.c
CSRC += stm32f1xx_ll_dma.c
CSRC += stm32f1xx_ll_exti.c
CSRC += stm32f1xx_ll_fsmc.c
CSRC += stm32f1xx_ll_gpio.c
CSRC += stm32f1xx_ll_i2c.c
CSRC += stm32f1xx_ll_pwr.c
CSRC += stm32f1xx_ll_rcc.c
CSRC += stm32f1xx_ll_rtc.c
CSRC += stm32f1xx_ll_sdmmc.c
CSRC += stm32f1xx_ll_spi.c
CSRC += stm32f1xx_ll_tim.c
CSRC += stm32f1xx_ll_usart.c
CSRC += stm32f1xx_ll_usb.c
CSRC += stm32f1xx_ll_utils.c
CSRC += Legacy/stm32f1xx_hal_can.c

INC  = -I ./inc
INC += -I ./inc/Legacy
INC += -I ../cmsisstm32f1xx/inc
INC += -I ../cmsiscore/inc

OBJ = $(CSRC:.c=.o)

.PRECIOUS: $(SRCDIR)/%.c
.PRECIOUS: $(BINDIR)/%.o

lib_stm32f1hal: $(BINDIR) $(BINDIR)/$(LIBOUTFILE)
	@echo "[Make][$(LIBNAME)] Finished."

$(BINDIR)/%.o: $(SRCDIR)/%.c
	@if ! test -d $(dir $@); then mkdir $(dir $@); echo "[Make][lib_stm32f1hal] Creating subdirectory for output binaries: $(dir $@)"; fi
	@echo "[ARM-GCC][$(LIBNAME)] Compiling $< -> $@"
	@$(CC) -c $(CFLAGS) $(INC) $< -o $@

$(BINDIR)/%.a: $(addprefix $(BINDIR)/, $(OBJ))
	@echo "[ARM-AR][$(LIBNAME)] Archiving library $@..."
	@if test -f $@; then rm $@; fi
	@$(AR) -rcs $@ $(addprefix $(BINDIR)/, $(OBJ))
	@echo "[ARM-AR][$(LIBNAME)] Archived."

$(BINDIR):
	@echo "[Make][$(LIBNAME)] Creating bin output folder."
	@mkdir $(BINDIR)

.PHONY: clean
clean:
	@echo "[Make][$(LIBNAME)] Cleaning up bin directory."
	@if test -d $(BINDIR); then rm -rf $(BINDIR)/*; fi
	@echo "[Make][$(LIBNAME)] Cleaned up."

.PHONY: rebuild
rebuild: clean module_core