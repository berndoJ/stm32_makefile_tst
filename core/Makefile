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

INC  = -I ./inc
INC += -I $(LIBDIR)/stm32f1hal/inc
INC += -I $(LIBDIR)/cmsiscore/inc
INC += -I $(LIBDIR)/cmsisstm32f1xx/inc

OBJ = $(CPPSRC:.cpp=.o)

.PRECIOUS: $(BINDIR)/%.o
.PRECIOUS: $(SRCDIR)/%.c

module_core: $(BINDIR) $(BINDIR)/$(LIBOUTFILE)
	@echo "[Make][$(LIBNAME)] Finished."

$(BINDIR)/%.o: $(SRCDIR)/%.cpp
	@if ! test -d $(dir $@); then mkdir $(dir $@); echo "[Make][$(LIBNAME)] Creating subdirectory for output binaries: $(dir $@)"; fi
	@echo "[ARM-GCC][$(LIBNAME)] Compiling $< -> $@"
	@$(CPPC) -c $(CPPFLAGS) $(INC) $< -o $@

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