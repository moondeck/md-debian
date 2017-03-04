#!/bin/bash

if [[ $3 == "orangepi" ]]; then
    git clone https://github.com/SvenKayser/Sambooca-Kernel-H3.git --branch sun8i --depth 1
    cd Sambooca-Kernel-H3
    make -j`nproc` ARCH=arm CC=$1 CROSS_COMPILE=$2
    make ARCH=arm CC=$1 CROSS_COMPILE=$2 INSTALL_MOD_PATH=../rootfs modules_install
    cd ..
    echo "Grabbed and compiled the kernel!"
else
    git clone https://github.com/moondeck/md-linux --depth 1
    cd md-linux
    make ARCH=arm CC=$1 CROSS_COMPILE=$2 medionbox_defconfig
    make -j`nproc` ARCH=arm CC=$1 CROSS_COMPILE=$2
    make ARCH=arm CC=$1 CROSS_COMPILE=$2 INSTALL_MOD_PATH=../rootfs modules_install
    cd ..
    echo "Grabbed and compiled the kernel!"
fi
