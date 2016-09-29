#!/bin/bash

git clone https://github.com/SvenKayser/Sambooca-Kernel-H3.git --branch sun8i --depth 1
cd Sambooca-Kernel-H3
cat Armbian-sun8i-patches/*.patch | patch -p1
make ARCH=arm CC=$1 CROSS_COMPILE=$2
cd ..
echo "Grabbed and compiled the kernel!"
