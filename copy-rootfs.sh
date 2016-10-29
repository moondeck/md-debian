#!/bin/bash

sync
losetup /dev/loop0 distimage.img
partprobe /dev/loop0
mkfs.ext2 /dev/loop0p1
mount /dev/loop0p1 /mnt
cp utils/* $1/usr/sbin
chmod -R 744 $1/usr/sbin

chown -R man /var/cache/man

cp Sambooca-Kernel-H3/arch/arm/boot/zImage $1/boot/
cp script_bin/$2_script.bin $1/boot/script.bin
cp boot_scr/$2_boot.scr $1/boot/boot.scr

mkdir $1/md-debian
cp u-boot-sunxi-with-spl.bin $1/md-debian

if [[ $2 = "orangepi_pc_plus" ]]; then
  cp utils/install2emmc.sh $1/usr/bin
fi

cp -r $1/* /mnt
sync
umount /mnt
dd if=u-boot-sunxi-with-spl.bin of=/dev/loop0 bs=1024 seek=8 conv=notrunc
losetup -d /dev/loop0
