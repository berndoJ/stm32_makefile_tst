# Makefile for core module.
# Copyright (c) 2019 by Johannes Berndorfer

include ../project.mk

LIBNAME = module_core
LIBOUTFILE = libmodcore.a
BINDIR = ./bin
SRCDIR = ./src
LIBDIR = ../lib

CPPSRC  = main.cpp
CPPSRC += sys_gpio.cpp
CPPSRC += sys_isr.cpp
CPPSRC += sys_clock.cpp
CPPSRC += sys_init.cpp
CPPSRC += sys_error.cpp
CPPSRC += syscalls.cpp

ASMSRC  = startup_stm32f103x6.s

INC  = -I ./inc
INC += -I $(LIBDIR)/stm32f1hal/inc
INC += -I $(LIBDIR)/cmsiscore/inc
INC += -I $(LIBDIR)/cmsisstm32f1xx/inc

OBJ = $(CPPSRC:.cpp=.o) $(ASMSRC:.s=.o)

.PRECIOUS: $(BINDIR)/%.o
.PRECIOUS: $(SRCDIR)/%.cpp

module_core: $(BINDIR)/$(LIBOUTFILE)
	@echo "[Make][$(LIBNAME)] Finished."

$(BINDIR)/%.o: $(SRCDIR)/%.cpp | $(BINDIR)
	@if ! test -d $(dir $@); then mkdir $(dir $@); echo "[Make][$(LIBNAME)] Creating subdirectory for output binaries: $(dir $@)"; fi
	@echo "[ARM-GCC][$(LIBNAME)] Compiling $< -> $@"
	@$(CPPC) -c $(CPPFLAGS) $(INC) $< -o $@

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