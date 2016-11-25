#!/bin/bash

# BUILD CONFIGURATION HERE, CHANGE IF NEEDED!!!

CROSS_COMPILE=arm-linux-gnueabihf-
CC=arm-linux-gnueabihf-gcc-5
SYS_VERSION=
ARCH=armhf
CARDSIZE=2048                       # size of the image, can be down to about 700mb for a usable minimal nogui image.

whoami > .tmp_who


if [[ ! ($(cat .tmp_who) == "root") ]]; then
  echo "you are not root!"
  exit
fi

dialog --backtitle "moonbian build system || created by moondeck ||" \
      --menu "Select OS version" 20 70 25 "Debian Jessie" "" \
      "Debian Stretch (dummy option)" "" 2> .tmp_system

dialog --backtitle "moonbian build system || created by moondeck ||" \
      --menu "Select board" 20 70 25 "Orange Pi One" "" \
      "Orange Pi PC+" "" \
      "Orange Pi PC" "" \
      "Orange Pi Plus 2E" "" 2> .tmp_board

dialog --backtitle "moonbian build system || created by moondeck ||" \
      --menu "Select board" 20 70 25 "XFCE" "" \
      "JWM (dummy option)" "" 2> .tmp_wm

dialog --nocancel --backtitle "moonbian build system || created by moondeck ||" \
      --inputbox "Input image verison" 10 70 2> .tmp_version

if [[ ! ($? == 0)]]; then
  echo "moonbian build script exiting..."
  rm -rf md-debian sun8i rootfs distimage.img Sambooca-Kernel-H3 u-boot u-boot-sunxi-with-spl.bin
  rm .tmp*
  exit
fi

VERSION=$(cat .tmp_version)

case $(cat .tmp_board) in
  "Orange Pi One" )
    TARGET_BOARD="orangepi_one"
    BOARD_SERIES="orangepi";;

  "Orange Pi PC+" )
    TARGET_BOARD="orangepi_pc_plus"
    BOARD_SERIES="orangepi";;

  "Orange Pi PC" )
    TARGET_BOARD="orangepi_pc"
    BOARD_SERIES="orangepi";;

  "Orange Pi Plus 2E" )
    TARGET_BOARD="orangepi_plus2e"
    BOARD_SERIES="orangepi"

esac

case $(cat .tmp_system) in
  "Debian Jessie" )
    SYS_VERSION="jessie";;

  "Debian Stretch" )
    SYS_VERSION="stretch"

esac

case $(cat .tmp_wm) in
  "Debian Jessie" )
    WINDOW_MANAGER="xfce";;

  "JWM" )
    WINDOW_MANAGER="jwm"

esac
clear

rm -rf md-debian sun8i rootfs *.img Sambooca-Kernel-H3 u-boot u-boot-sunxi-with-spl.bin *.tar.gz

wget http://repo.novakovsky.eu/moonbian/$SYS_VERSION/rootfs.tar.gz

tar -xf rootfs.tar.gz
rm -rf *.tar.gz

cp /etc/resolv.conf rootfs/etc
cp utils/chrootscript-$SYS_VERSION rootfs/bin/
chmod 774 rootfs/bin/chrootscript-$SYS_VERSION
chroot rootfs /bin/bash -c "chrootscript-$SYS_VERSION $WINDOW_MANAGER && exit"
rm rootfs/bin/chrootscript-$SYS_VERSION

./getuboot.sh $TARGET_BOARD $CROSS_COMPILE $CC

./getkern.sh $CC $CROSS_COMPILE

dd if=/dev/zero of=$TARGET_BOARD-$VERSION-$WINDOW_MANAGER-image.img bs=1M count=$CARDSIZE
sync

./partition.sh $TARGET_BOARD $VERSION $WINDOW_MANAGER
./copy-rootfs.sh rootfs $TARGET_BOARD $VERSION $WINDOW_MANAGER


rm .tmp*
echo "moondeck's debian build system done. thanks."
