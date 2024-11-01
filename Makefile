AC=nasm
CC=gcc
CC16=/usr/bin/watcom/binl64/wcc
CL16=/usr/bin/watcom/binl64/wlink

SRC_DIR=src
BUILD_DIR=build

.PHONY: all clean always image bootloader

always:
	mkdir -p build

clean:
	rm -rf build
	rm *.mem

all: image

image: $(BUILD_DIR)/os.img

$(BUILD_DIR)/os.img: bootloader 
	dd if=/dev/zero of=$(BUILD_DIR)/os.img bs=1M count=10
	dd if=/dev/zero of=$(BUILD_DIR)/root.img bs=1M count=8
	dd if=/dev/zero of=$(BUILD_DIR)/boot.img bs=512 count=2000
	mkfs.ext2 $(BUILD_DIR)/root.img
	dd if=$(BUILD_DIR)/boot/bootl.bin of=$(BUILD_DIR)/boot.img conv=notrunc
	dd if=$(BUILD_DIR)/boot/ssbootl.bin of=$(BUILD_DIR)/boot.img conv=notrunc seek=4
	dd if=$(BUILD_DIR)/root.img of=$(BUILD_DIR)/os.img conv=notrunc seek=2
	dd if=$(BUILD_DIR)/boot.img of=$(BUILD_DIR)/os.img conv=notrunc

bootloader: stage1 stage2

stage1: $(BUILD_DIR)/boot/bootl.bin

$(BUILD_DIR)/boot/bootl.bin: always
	$(MAKE) -C $(SRC_DIR)/boot/bootl BUILD_DIR=$(abspath $(BUILD_DIR))

stage2: $(BUILD_DIR)/boot/ssbootl.bin 

$(BUILD_DIR)/boot/ssbootl.bin: always
	$(MAKE) -C $(SRC_DIR)/boot/ssbootl BUILD_DIR=$(abspath $(BUILD_DIR))

