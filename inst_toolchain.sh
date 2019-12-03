# Shell script for installing the toolchain needed to build this project.
# Copyright (c) 2019 by Johannes Berndorfer

apt-get install gcc-arm-none-eabi 
apt-get install binutils-arm-none-eabi
apt-get install gdb-arm-none-eabi
apt-get install openocd