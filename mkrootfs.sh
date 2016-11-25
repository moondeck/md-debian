#!/bin/bash
debootstrap --arch=$(ARCH) --foreign $(SYS_VERSION) $(TARGET_ROOTFS)
