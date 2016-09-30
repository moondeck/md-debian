#!/bin/bash

git clone git://git.denx.de/u-boot.git --depth 1
cd u-boot
make CROSS_COMPILE=$2 CC=$3 $1_defconfig
make CROSS_COMPILE=$2 CC=$3
cp u-boot-sunxi-with-spl.bin ..
cd ..
