#!/bin/bash

# BUILD CONFIGURATION HERE, CHANGE IF NEEDED!!!

CROSS_COMPILE=arm-linux-gnueabihf-
CC=arm-linux-gnueabihf-gcc
SYS_VERSION=
ARCH=armhf
CARDSIZE=1024                       # size of the image, can be down to about 700mb for a usable minimal nogui image.

# END OF BUILD CONFIG


whoami > .tmp_who
if [[ ! ($(cat .tmp_who) == "root") ]]; then
  echo "you are not root!"
  exit
fi

if [[ $1 == "--help" || $1 == "-h" || $# < 5 ]]; then
  echo "Usage: build.sh system board board_series wm img_version"
  echo "See moondeck.github.io/md-debian for an up-to-date list of options"
  exit
fi

if [[ ! ($? == 0)]]; then
  echo "moonbian build script exiting..."
  rm -rf md-debian sun8i rootfs distimage.img Sambooca-Kernel-H3 u-boot u-boot-sunxi-with-spl.bin
  rm .tmp*
  exit
fi

VERSION=$5
TARGET_BOARD=$2
BOARD_SERIES=$3
SYS_VERSION=$1
WINDOW_MANAGER=$4

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

./getkern.sh $CC $CROSS_COMPILE $BOARD_SERIES

dd if=/dev/zero of=$TARGET_BOARD-$VERSION-$WINDOW_MANAGER-image.img bs=1M count=$CARDSIZE
sync

./partition.sh $TARGET_BOARD $VERSION $WINDOW_MANAGER
./copy-rootfs.sh rootfs $TARGET_BOARD $VERSION $WINDOW_MANAGER


rm .tmp*
echo "moondeck's debian build system done. thanks."
