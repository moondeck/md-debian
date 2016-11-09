#!/bin/bash

# BUILD CONFIGURATION HERE, CHANGE IF NEEDED!!!

CROSS_COMPILE=arm-linux-gnueabihf-
CC=arm-linux-gnueabihf-gcc-5
SYS_VERSION=jessie
ARCH=armhf
CARDSIZE=2048                       # size of the image, can be down to about 700mb for a usable minimal nogui image.
TARGET_BOARD=
WINDOW_MANAGER=                #must be "nogui" if no WM
VERSION=1.0.0
RETURN_BOARD=0

whoami > .tmp_who


if [[ ! ($(cat .tmp_who) == "root") ]]; then
  echo "you are not root!"
  exit
fi

dialog --backtitle "moonbian build system || created by moondeck ||" \
      --menu "Select board" 20 40 25 "Orange Pi One Debian CLI" "" \
      "Orange Pi One Debian XFCE" "" \
      "Orange Pi PC+ Debian CLI" "" \
      "Orange Pi PC+ Debian XFCE" "" \
      "Orange Pi PC Debian CLI" "" \
      "Orange Pi PC Debian XFCE" "" \
      "Make image" "" 2> .tmp_board

if [[ ! ($? == 0)]]; then
  echo "moonbian build script exiting..."
  rm -rf md-debian sun8i rootfs distimage.img Sambooca-Kernel-H3 u-boot u-boot-sunxi-with-spl.bin
  rm .tmp*
  exit
fi

case $(cat .tmp_board) in
  "Orange Pi One Debian CLI" )
    TARGET_BOARD="orangepi_one"
    WINDOW_MANAGER="nogui";;
  "Orange Pi One Debian XFCE")
    TARGET_BOARD="orangepi_one"
    WINDOW_MANAGER="xfce";;
  "Orange Pi PC+ Debian CLI")
    TARGET_BOARD="orangepi_pc_plus"
    WINDOW_MANAGER="nogui";;
  "Orange Pi PC+ Debian XFCE")
    TARGET_BOARD="orangepi_pc_plus"
    WINDOW_MANAGER="xfce";;
  "Orange Pi PC Debian CLI")
    TARGET_BOARD="orangepi_pc"
    WINDOW_MANAGER="nogui";;
  "Orange Pi PC Debian XFCE")
    TARGET_BOARD="orangepi_pc"
    WINDOW_MANAGER="xfce";;
  "Make image")
    TARGET_BOARD="rootfsbuild"
    WINDOW_MANAGER="notforuse"
    VERSION="RFS"
    ./mkimage.sh $TARGET_BOARD $VERSION $WINDOW_MANAGER
    exit
esac

clear

rm -rf md-debian sun8i rootfs *.img Sambooca-Kernel-H3 u-boot u-boot-sunxi-with-spl.bin *.tar.gz

wget http://repo.novakovsky.eu/moonbian/$SYS_VERSION/rootfs.tar.gz

tar -xf rootfs.tar.gz
rm -rf *.tar.gz

cp /etc/resolv.conf rootfs/etc
cp utils/chrootscript rootfs/bin/
chmod 774 rootfs/bin/chrootscript
chroot rootfs /bin/bash -c "chrootscript $WINDOW_MANAGER && exit"
rm rootfs/bin/chrootscript

./getuboot.sh $TARGET_BOARD $CROSS_COMPILE $CC

./getkern.sh $CC $CROSS_COMPILE $TARGET_ROOTFS

dd if=/dev/zero of=$TARGET_BOARD-$VERSION-$WINDOW_MANAGER-image.img bs=1M count=$CARDSIZE
sync

./partition.sh $TARGET_BOARD $VERSION $WINDOW_MANAGER
./copy-rootfs.sh rootfs $TARGET_BOARD $VERSION $WINDOW_MANAGER

rm -rf md-debian sun8i rootfs distimage.img Sambooca-Kernel-H3 u-boot u-boot-sunxi-with-spl.bin
rm .tmp*
echo "moondeck's debian build system done. thanks."
