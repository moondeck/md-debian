#!/bin/bash

sync
losetup /dev/loop0 distimage.img
partprobe /dev/loop0
mkfs.ext2 /dev/loop0p1
mount /dev/loop0p1 /mnt
cp Sambooca-Kernel-H3/arch/arm/boot/zImage $1/boot/
cp script_bin/$2_script.bin $1/boot/script.bin
cp boot_scr/$2_boot.scr $1/boot/boot.scr
cp -r $1/* /mnt
sync
umount /mnt
dd if=u-boot-sunxi-with-spl.bin of=/dev/loop0 bs=1024 seek=8 conv=notrunc 
losetup -d /dev/loop0
