#--------------------------------------------------
# MAKEFILE - STM32TCTST Project
#--------------------------------------------------
# Copyright (c) 2019 by Johannes Berndorfer
# Created 11/30/2019
#--------------------------------------------------

PROJECTNAME = stm32tctst
MCUTYPE = cortex-m3
BINFOLDER = ./bin

CPREFIX = arm-none-eabi-
CC      = $(CPREFIX)gcc
CPPC    = $(CC)
OBJCP   = $(CPREFIX)objcopy
ASM     = $(CPREFIX)gcc -x assembler-with-cpp
GDBTUI  = $(CPREFIX)gdbtui
CSIZE   = $(CPREFIX)size

# --- C/CPP DEFINES ---
CDEFS =

# --- OPTIMISATION LEVEL FLAGS ---
OPTIM = -Os

# --- COMPILER FLAGS ---
COMPDEFS = $(CDEFS) -DRUN_FROM_FLASH=1

MCUFLAGS = -mcpu=$(MCUTYPE)
CCFLAGS = $(MCUFLAGS) $(OPTIM) -g -gdwarf-2 -mthumb -fomit-frame-pointer -Wall -fverbose-asm -Wa,-ahlms=$(<:.c=.lst) $(COMPDEFS)
CPPFLAGS = $(MCUFLAGS) $(OPTIM) -g -gdwarf-2 -mthumb -fomit-frame-pointer -Wall -fverbose-asm -Wa,-ahlms=$(<:.cpp=.lst) $(COMPDEFS)
ASMFLAGS = $(MCUFLAGS) -g -gdwarf-2 -mthumb -Wa,-amhls=$(<:.s=.lst)

# --- INCLUDE DIRECTORIES ---
INC = ./inc

# --- SOURCE FILES ---
CSRC = 

ASMSRC =

CPPSRC = ./src/main.cpp
CPPSRC += ./src/sys_isr.cpp
CPPSRC += ./src/sys_gpio.cpp


LDFLAGS =
LIBS =

OBJ = $(ASMSRC:.s=.o) $(CSRC:.c=.o) $(CPPSRC:.cpp=.o)

# --- FILE COMPILATION PROCEDURES ---

%o: %c
	$(CC) -c $(CCFLAGS) -I . $(INC) $< -o $(BINFOLDER)/$@

%o: %s
	$(ASM) -c $(ASMFLAGS) $< -o $(BINFOLDER)/$@

%o: %cpp
	$(CPPC) -c $(CPPFLAGS) -I $(INC) $< -o $(BINFOLDER)/$@


%elf: $(OBJ)
	$(CC) $(OBJ) $(LDFLAGS) $(LIBS) -o $(BINFOLDER)/$@

%hex: $elf
	$(OBJCP) -O ihex $(BINFOLDER)/$< $(BINFOLDER)/$@

%bin: $elf
	$(OBJCP) -O binary -S $(BINFOLDER)/$< $(BINFOLDER)/$@

# --- MAKEFILE TARGETS ---

all: $(OBJS) $(PROJECTNAME).elf $(PROJECTNAME).hex $(PROJECTNAME).bin
	$(CSIZE) $(PORJECTNAME).elf

clean:
	rm -rf $(BINFOLDER)/*.o
	rm -rf $(BINFOLDER)/*.elf
	rm -rf $(BINFOLDER)/*.bin
	rm -rf $(BINFOLDER)/*.hex