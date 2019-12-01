# Makefile for core module.
# Copyright (c) 2019 by Johannes Berndorfer

CDEFS += -D__MODULE_CORE

CPPSRC += ./src/main.cpp
CPPSRC += ./src/sys_gpio.cpp
CPPSRC += ./src/sys_isr.cpp

INC += -I ./inc