#!/bin/bash

sync
losetup /dev/loop0 $2-$3-$4-image.img
partprobe /dev/loop0
mkfs.ext2 /dev/loop0p1
mount /dev/loop0p1 /mnt
cp utils/* rootfs/usr/sbin
chmod -R 744 rootfs/usr/sbin

chown -R man /var/cache/man

cp Sambooca-Kernel-H3/arch/arm/boot/zImage rootfs/boot/
cp script_bin/$2_script.bin rootfs/boot/script.bin
cp boot_scr/$2_boot.scr rootfs/boot/boot.scr

mkdir rootfs/md-debian
cp u-boot-sunxi-with-spl.bin rootfs/md-debian

if [[ $2 = "orangepi_pc_plus" || $2 = "orangepi_plus2e" ]]; then
  cp utils/install2emmc.sh rootfs/usr/bin
fi

cp -r rootfs/* /mnt
sync
umount /mnt
dd if=u-boot-sunxi-with-spl.bin of=/dev/loop0 bs=1024 seek=8 conv=notrunc
losetup -d /dev/loop0
