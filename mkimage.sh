#!/bin/bash

CARDSIZE=2048                       # size of the image, can be down to about 700mb for a usable minimal nogui image.
TARGET_BOARD=$1
WINDOW_MANAGER=$3                #must be "nogui" if no WM
VERSION=$2

dd if=/dev/zero of=$TARGET_BOARD-$VERSION-$WINDOW_MANAGER-image.img bs=1M count=$CARDSIZE
sync

./partition.sh $TARGET_BOARD $VERSION $WINDOW_MANAGER
./copy-rootfs.sh rootfs $TARGET_BOARD $VERSION $WINDOW_MANAGER
