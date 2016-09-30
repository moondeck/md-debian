CROSS_COMPILE=arm-linux-gnueabihf-
CC=arm-linux-gnueabihf-gcc-5
TARGET_ROOTFS=rootfs
SYS_VERSION=jessie
ARCH=armhf
CARDSIZE=8192
TARGET_BOARD=orangepi_one

bootimage:
	rm -rf md-debian sun8i rootfs distimage.img Sambooca-Kernel-H3 u-boot u-boot-sunxi-with-spl.bin
	debootstrap --arch=$(ARCH) --foreign $(SYS_VERSION) $(TARGET_ROOTFS)
	cp /usr/bin/qemu-arm-static $(TARGET_ROOTFS)/usr/bin
	chroot $(TARGET_ROOTFS) qemu-arm-static /bin/bash -c "/debootstrap/debootstrap --second-stage && dpkg --configure -a && tasksel && passwd && exit"

	./getuboot.sh $(TARGET_BOARD) $(CROSS_COMPILE) $(CC)

	./getkern.sh $(CC) $(CROSS_COMPILE) $(TARGET_ROOTFS)

	dd if=/dev/zero of=distimage.img bs=1M count=$(CARDSIZE)
	sync

	./partition.sh
	./copy-rootfs.sh $(TARGET_ROOTFS) $(TARGET_BOARD)


clean:
	rm -rf md-debian sun8i rootfs distimage.img Sambooca-Kernel-H3 u-boot u-boot-sunxi-with-spl.bin

kernel:
	./getkern.sh $(CC) $(CROSS_COMPILE) $(TARGET_ROOTFS)

uboot:
	./getuboot.sh $(TARGET_BOARD) $(CROSS_COMPILE) $(CC)
