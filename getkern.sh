#!/bin/bash

git clone https://github.com/SvenKayser/Sambooca-Kernel-H3.git --branch sun8i --depth 1
cd Sambooca-Kernel-H3
make -j`nproc` ARCH=arm CC=$1 CROSS_COMPILE=$2
make ARCH=arm CC=$1 CROSS_COMPILE=$2 INSTALL_MOD_PATH=../$3 modules_install
cd ..
echo "Grabbed and compiled the kernel!"
