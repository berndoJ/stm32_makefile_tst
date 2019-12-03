# Project variable definition makefile
# Copyright (c) 2019 by Johannes Berndorfer

# --- PROJECT INFOS ---
PROJECTNAME = stm32tctst
PLATFORM    = STM32F103
MCUTYPE     = cortex-m3

# --- VERSION ---
VERSION_MAJOR = 1
VERSION_MINOR = 0

# --- COMPILER DEFINITIONS ---
CPREFIX = arm-none-eabi-
CC      = $(CPREFIX)gcc
CPPC    = $(CC)
OBJCP   = $(CPREFIX)objcopy
ASM     = $(CPREFIX)gcc -x assembler-with-cpp
GDBTUI  = $(CPREFIX)gdbtui
CSIZE   = $(CPREFIX)size
AR		= $(CPREFIC)ar

# --- C/CPP DEFINES ---
CDEFS = -DSTM32F103x6

# --- OPTIMISATION LEVEL FLAGS ---
OPTIM = -Os

# --- COMPILER FLAGS ---
COMPDEFS = $(CDEFS) -DRUN_FROM_FLASH=1

MCUFLAGS = -mcpu=$(MCUTYPE)
CFLAGS = $(MCUFLAGS) $(OPTIM) -g -gdwarf-2 -mthumb -fomit-frame-pointer -Wall -fverbose-asm -Wa,-ahlms=$(<:.c=.lst) $(COMPDEFS)
CPPFLAGS = $(MCUFLAGS) $(OPTIM) -g -gdwarf-2 -mthumb -fomit-frame-pointer -Wall -fverbose-asm -Wa,-ahlms=$(<:.cpp=.lst) $(COMPDEFS)
ASMFLAGS = $(MCUFLAGS) -g -gdwarf-2 -mthumb -Wa,-amhls=$(<:.s=.lst)