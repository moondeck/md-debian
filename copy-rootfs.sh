#!/bin/bash

sudo sync
sudo losetup /dev/loop0 distimage.img
sudo partprobe /dev/loop0
sudo mkfs.ext2 /dev/loop0p1
sudo mount /dev/loop0p1 /mnt
sudo cp -r $1/* /mnt
sudo sync
sudo umount /mnt
sudo losetup -d /dev/loop0
