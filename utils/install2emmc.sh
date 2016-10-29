#!/bin/bash

dd if=/dev/zero of=/dev/mmcblk1 bs=8M count=1

fdisk /dev/mmcblk1 <<EOF
o
n
p
1


w
q
EOF

mkfs.ext2 /dev/mmcblk1p1

mount /dev/mmcblk1p1 /mnt

cp -r /bin /dev /home /run /srv /tmp /var /boot /etc /lib /media /opt /root /sbin /usr --target-directory=/mnt

umount /mnt

#make this download uboot from the repo

dd if=/md-debian/u-boot-sunxi-with-spl.bin of=/dev/mmcblk1 bs=1024 seek=8 conv=notrunc


echo "
Thank you for using md-debian
Once system halts, eject the SD and boot from eMMC!
"

rm /root/.bash_history

halt
