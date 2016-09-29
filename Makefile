CROSS_COMPILE=arm-linux-gnueabihf-
CC=arm-linux-gnueabihf-gcc-5
TARGET_ROOTFS=rootfs
SYS_VERSION=jessie
ARCH=armhf
CARDSIZE=1024

bootimage:
	sudo rm -rf md-debian sun8i rootfs distimage.img Sambooca-Kernel-H3
	sudo debootstrap --arch=$(ARCH) --foreign $(SYS_VERSION) $(TARGET_ROOTFS)
	sudo cp /usr/bin/qemu-arm-static $(TARGET_ROOTFS)/usr/bin
	sudo chroot $(TARGET_ROOTFS) qemu-arm-static /bin/bash -c "/debootstrap/debootstrap --second-stage && dpkg --configure -a && exit"

	./getkern.sh $(CC) $(CROSS_COMPILE)

	sudo dd if=/dev/zero of=distimage.img bs=1M count=$(CARDSIZE)
	sudo sync
	./partition.sh
	./copy-rootfs.sh $(TARGET_ROOTFS)
	sudo rm -rf md-debian sun8i rootfs Sambooca-Kernel-H3

clean:
	sudo rm -rf md-debian sun8i rootfs distimage.img Sambooca-Kernel-H3
