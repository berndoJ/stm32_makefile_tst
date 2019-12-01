# Makefile for STM32F1 HAL library.
# Copyright (c) 2019 by Johannes Berndorfer

include ../../project.mk

CSRC = ./src/stm32f1xx_hal.c
CSRC += ./src/stm32f1xx_hal_can.c
CSRC += ./src/stm32f1xx_hal_adc.c
CSRC += ./src/stm32f1xx_hal_adc_ex.c
CSRC += ./src/stm32f1xx_hal_can.c
CSRC += ./src/stm32f1xx_hal_cec.c
CSRC += ./src/stm32f1xx_hal_cortex.c
CSRC += ./src/stm32f1xx_hal_crc.c
CSRC += ./src/stm32f1xx_hal_dac.c
CSRC += ./src/stm32f1xx_hal_dac_ex.c
CSRC += ./src/stm32f1xx_hal_dma.c
CSRC += ./src/stm32f1xx_hal_eth.c
CSRC += ./src/stm32f1xx_hal_exti.c
CSRC += ./src/stm32f1xx_hal_flash.c
CSRC += ./src/stm32f1xx_hal_flash_ex.c
CSRC += ./src/stm32f1xx_hal_gpio.c
CSRC += ./src/stm32f1xx_hal_gpio_ex.c
CSRC += ./src/stm32f1xx_hal_hcd.c
CSRC += ./src/stm32f1xx_hal_i2c.c
CSRC += ./src/stm32f1xx_hal_i2s.c
CSRC += ./src/stm32f1xx_hal_irda.c
CSRC += ./src/stm32f1xx_hal_iwdg.c
CSRC += ./src/stm32f1xx_hal_mmc.c
CSRC += ./src/stm32f1xx_hal_msp_template.c
CSRC += ./src/stm32f1xx_hal_nand.c
CSRC += ./src/stm32f1xx_hal_nor.c
CSRC += ./src/stm32f1xx_hal_pccard.c
CSRC += ./src/stm32f1xx_hal_pcd.c
CSRC += ./src/stm32f1xx_hal_pcd_ex.c
CSRC += ./src/stm32f1xx_hal_pwr.c
CSRC += ./src/stm32f1xx_hal_rcc.c
CSRC += ./src/stm32f1xx_hal_rcc_ex.c
CSRC += ./src/stm32f1xx_hal_rtc.c
CSRC += ./src/stm32f1xx_hal_rtc_ex.c
CSRC += ./src/stm32f1xx_hal_sd.c
CSRC += ./src/stm32f1xx_hal_smartcard.c
CSRC += ./src/stm32f1xx_hal_spi.c
CSRC += ./src/stm32f1xx_hal_sram.c
CSRC += ./src/stm32f1xx_hal_tim.c
CSRC += ./src/stm32f1xx_hal_timebase_rtc_alarm_template.c
CSRC += ./src/stm32f1xx_hal_timebase_tim_template.c
CSRC += ./src/stm32f1xx_hal_tim_ex.c
CSRC += ./src/stm32f1xx_hal_uart.c
CSRC += ./src/stm32f1xx_hal_usart.c
CSRC += ./src/stm32f1xx_hal_wwdg.c
CSRC += ./src/stm32f1xx_ll_adc.c
CSRC += ./src/stm32f1xx_ll_crc.c
CSRC += ./src/stm32f1xx_ll_dac.c
CSRC += ./src/stm32f1xx_ll_dma.c
CSRC += ./src/stm32f1xx_ll_exti.c
CSRC += ./src/stm32f1xx_ll_fsmc.c
CSRC += ./src/stm32f1xx_ll_gpio.c
CSRC += ./src/stm32f1xx_ll_i2c.c
CSRC += ./src/stm32f1xx_ll_pwr.c
CSRC += ./src/stm32f1xx_ll_rcc.c
CSRC += ./src/stm32f1xx_ll_rtc.c
CSRC += ./src/stm32f1xx_ll_sdmmc.c
CSRC += ./src/stm32f1xx_ll_spi.c
CSRC += ./src/stm32f1xx_ll_tim.c
CSRC += ./src/stm32f1xx_ll_usart.c
CSRC += ./src/stm32f1xx_ll_usb.c
CSRC += ./src/stm32f1xx_ll_utils.c
CSRC += ./src/Legacy/stm32f1xx_hal_can.c

INC = -I ./inc
INC += -I ./inc/Legacy

OBJ = $(CSRC:.c=.o)

lib_stm32f1_hal: $(OBJ)

%.o: %.c $(BINFOLDER)
	$(CC) -c $(CFLAGS) $(INC) $< -o ./bin/$(notdir $@)

#%o: %s
#	@$(ASM) -c $(ASMFLAGS) $< -o $(BINFOLDER)/$@
#
#%o: %cpp
#	@$(CPPC) -c $(CPPFLAGS) $(INC) $< -o $(BINFOLDER)/$@
#
#%elf: $(OBJ)
#	@$(CC) $(OBJ) $(LDFLAGS) $(LIBS) -o $(BINFOLDER)/$@
#
#%hex: %elf
#	@$(OBJCP) -O ihex $(BINFOLDER)/$< $(BINFOLDER)/$@
#
#%bin: %elf
#	@$(OBJCP) -O binary -S $(BINFOLDER)/$< $(BINFOLDER)/$@
#
$(BINFOLDER):
	@mkdir $(BINFOLDER)