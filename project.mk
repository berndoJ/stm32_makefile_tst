# Project variable definition makefile
# Copyright (c) 2019 by Johannes Berndorfer

# --- PROJECT INFOS ---
PROJECTNAME = stm32tctst
PLATFORM    = STM32F103X6
MCUTYPE     = cortex-m3
DEBUG       = 0
COPYRIGHT   = Copyright (c) 2019 by Johannes Berndorfer

# --- VERSION ---
VERSION_MAJOR = 1
VERSION_MINOR = 0

# --- COMPILER DEFINITIONS ---
CPREFIX = arm-none-eabi-
CC      = $(CPREFIX)gcc
CPPC    = $(CPREFIX)g++
LD      = $(CC)
OBJCP   = $(CPREFIX)objcopy
ASM     = $(CPREFIX)gcc -x assembler-with-cpp
GDBTUI  = $(CPREFIX)gdbtui
CSIZE   = $(CPREFIX)size
AR		= $(CPREFIC)ar

# --- C/CPP COMMON DEFINES ---
CDEFS  = -DSTM32F103x6
CDEFS += -DUSE_HAL_DRIVER
CDEFS += -DVERSION_MAJOR=$(VERSION_MAJOR)
CDEFS += -DVERSION_MINOR=$(VERSION_MINOR)
CDEFS += -DVERSION_STR="$(VERSION_MAJOR).$(VERSION_MINOR)"

# --- COMPILER OPTIMISATION FLAGS ---
OPTIM = -Os

# --- COMPILER FLAGS ---
MCUFLAGS = -mcpu=$(MCUTYPE) -mthumb
DEBUGFLAGS = -g -gdwarf-2
CFLAGS = $(MCUFLAGS) $(OPTIM) $(CDEFS) -Wall -fdata-sections -ffunction-sections -MMD -MP -MF"$(@:%.o=%.d)"
CPPFLAGS = $(CFLAGS) -Wa,-a,-ad,-ahlms=$(<:.cpp=.lst)
CFLAGS += -Wa,-a,-ad,-ahlms=$(<:.c=.lst)
#-g -gdwarf-2 -fomit-frame-pointer -Wall -fverbose-asm -Wa,-ahlms=$(<:.cpp=.lst) $(COMPDEFS)
ASMFLAGS = $(MCUFLAGS) $(OPTIM) -Wall -fdata-sections -ffunction-sections
#-g -gdwarf-2 -Wa,-amhls=$(<:.s=.lst)

ifeq ($(DEBUG), 1)
CFLAGS += $(DEBUGFLAGS)
CPPFLAGS += $(DEBUGFLAGS)
endif

# --- LINKER SETTINGS ---
LDFLAGS = -T$(LINKERSCRIPT) $(MCUFLAGS) -specs=nano.specs -Wl,--gc-sections



# --- COLOR DEFINITIONS FOR TEXT OUTPUT ---

# Black        0;30     Dark Gray     1;30
# Red          0;31     Light Red     1;31
# Green        0;32     Light Green   1;32
# Brown/Orange 0;33     Yellow        1;33
# Blue         0;34     Light Blue    1;34
# Purple       0;35     Light Purple  1;35
# Cyan         0;36     Light Cyan    1;36
# Light Gray   0;37     White         1;37

C_BLACK = \033[0;30m
C_RED = \033[0;31m
C_GREEN = \033[0;32m
C_ORANGE = \033[0;33m
C_BLUE = \033[0;34m
C_PURPLE = \033[0;35m
C_CYAN = \033[0;36m
C_LGRAY = \033[0;37m
C_DGRAY = \033[1;30m
C_LRED = \033[1;31m
C_LGREEN = \033[1;32m
C_YELLOW = \033[1;33m
C_LBLUE = \033[1;34m
C_LPURPLE = \033[1;35m
C_LCYAN = \033[1;36m
C_WHITE = \033[1;37m
C_CLR = \033[0m
C_BOLD = \033[1m