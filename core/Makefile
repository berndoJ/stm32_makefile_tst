# Makefile for core module.
# Copyright (c) 2019 by Johannes Berndorfer

include ../project.mk

LIBNAME = module_core
LIBOUTFILE = libmodcore.a
BINDIR = ./bin
SRCDIR = ./src
LIBDIR = ../lib

CSRC  = main.c
CSRC += sys_gpio.c
CSRC += sys_isr.c
CSRC += sys_clock.c
CSRC += sys_init.c
CSRC += sys_error.c

ASMSRC  = startup_stm32f103x6.s

INC  = -I ./inc
INC += -I $(LIBDIR)/stm32f1hal/inc
INC += -I $(LIBDIR)/cmsiscore/inc
INC += -I $(LIBDIR)/cmsisstm32f1xx/inc

OBJ = $(CSRC:.c=.o) $(ASMSRC:.s=.o)

.PRECIOUS: $(BINDIR)/%.o
.PRECIOUS: $(SRCDIR)/%.c

module_core: $(BINDIR)/$(LIBOUTFILE)
	@echo "[Make][$(LIBNAME)] Finished."

$(BINDIR)/%.o: $(SRCDIR)/%.c | $(BINDIR)
	@if ! test -d $(dir $@); then mkdir $(dir $@); echo "[Make][$(LIBNAME)] Creating subdirectory for output binaries: $(dir $@)"; fi
	@echo "[ARM-GCC][$(LIBNAME)] Compiling $< -> $@"
	@$(CC) -c $(CFLAGS) $(INC) $< -o $@

$(BINDIR)/%.o: $(SRCDIR)/%.s | $(BINDIR)
	@if ! test -d $(dir $@); then mkdir $(dir $@); echo "[Make][$(LIBNAME)] Creating subdirectory for output binaries: $(dir $@)"; fi
	@echo "[ARM-GCC][$(LIBNAME)] Compiling $< -> $@"
	@$(ASM) -c $(ASMFLAGS) $< -o $@

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

-include $(wildcard $(BINDIR)/*.d)