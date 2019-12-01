#--------------------------------------------------
# MAKEFILE - STM32TCTST Project
#--------------------------------------------------
# Copyright (c) 2019 by Johannes Berndorfer
# Created 11/30/2019
#--------------------------------------------------

# --- PROJECT INFOS ---
PROJECTNAME = stm32tctst
PLATFORM    = STM32F103
MCUTYPE     = cortex-m3
BINFOLDER   = ./bin

# --- VERSION ---
VERSION_MAJOR = 1
VERSION_MINOR = 0

# --- BUILD NUMBER ---
BUILD_NUM_FILE = ./buildnum.dat
include ./buildnumber.mk

# --- COMPILER DEFINITIONS ---
CPREFIX = arm-none-eabi-
CC      = $(CPREFIX)gcc
CPPC    = $(CC)
OBJCP   = $(CPREFIX)objcopy
ASM     = $(CPREFIX)gcc -x assembler-with-cpp
GDBTUI  = $(CPREFIX)gdbtui
CSIZE   = $(CPREFIX)size

# --- C/CPP DEFINES ---
CDEFS = 

# --- SOURCECODE MODULES ---
include ./lib/stm32f1_hal/lib_stm32f1_hal.mk
include ./core/module_core.mk

# --- OPTIMISATION LEVEL FLAGS ---
OPTIM = -Os

# --- COMPILER FLAGS ---
COMPDEFS = $(CDEFS) -DRUN_FROM_FLASH=1

MCUFLAGS = -mcpu=$(MCUTYPE)
CFLAGS = $(MCUFLAGS) $(OPTIM) -g -gdwarf-2 -mthumb -fomit-frame-pointer -Wall -fverbose-asm -Wa,-ahlms=$(<:.c=.lst) $(COMPDEFS)
CPPFLAGS = $(MCUFLAGS) $(OPTIM) -g -gdwarf-2 -mthumb -fomit-frame-pointer -Wall -fverbose-asm -Wa,-ahlms=$(<:.cpp=.lst) $(COMPDEFS)
ASMFLAGS = $(MCUFLAGS) -g -gdwarf-2 -mthumb -Wa,-amhls=$(<:.s=.lst)

# --- INCLUDE DIRECTORIES ---
INC = 

# --- SOURCE FILES ---
CSRC = 
ASMSRC = 
CPPSRC = 

# --- LINKER SETTINGS ---
LDFLAGS =
LIBS =

# --- DEFINE COMPILATION OBJECTS
OBJ = $(ASMSRC:.s=.o) $(CSRC:.c=.o) $(CPPSRC:.cpp=.o)

# --- MAKEFILE TARGETS ---

all: $(OBJ) $(PROJECTNAME).elf $(PROJECTNAME).hex $(PROJECTNAME).bin
	$(CSIZE) $(PROJECTNAME).elf

.PHONY: clean
clean:
	rm -rf $(BINFOLDER)/*.o
	rm -rf $(BINFOLDER)/*.elf
	rm -rf $(BINFOLDER)/*.bin
	rm -rf $(BINFOLDER)/*.hex

# --- FILE COMPILATION PROCEDURES ---

%o: %c
	@$(CC) -c $(CFLAGS) $(INC) $< -o $(BINFOLDER)/$@

%o: %s
	@$(ASM) -c $(ASMFLAGS) $< -o $(BINFOLDER)/$@

%o: %cpp
	@$(CPPC) -c $(CPPFLAGS) $(INC) $< -o $(BINFOLDER)/$@


%elf: $(OBJ)
	@$(CC) $(OBJ) $(LDFLAGS) $(LIBS) -o $(BINFOLDER)/$@

%hex: %elf
	@$(OBJCP) -O ihex $(BINFOLDER)/$< $(BINFOLDER)/$@

%bin: %elf
	@$(OBJCP) -O binary -S $(BINFOLDER)/$< $(BINFOLDER)/$@

$(BINFOLDER):
	mkdir $(BINFOLDER)