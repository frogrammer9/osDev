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

all: image

image: $(BUILD_DIR)/os.img

$(BUILD_DIR)/os.img: bootloader 
	dd if=/dev/zero of=$(BUILD_DIR)/os.img bs=512 count=2880
	mkfs.fat -F 12 -n "NBOS" $(BUILD_DIR)/os.img
	dd if=$(BUILD_DIR)/boot/bootl.bin of=$(BUILD_DIR)/os.img conv=notrunc
	mcopy -i $(BUILD_DIR)/os.img test.txt "::test.txt"

bootloader: stage1 

stage1: $(BUILD_DIR)/boot/bootl.bin

$(BUILD_DIR)/boot/bootl.bin: always
	$(MAKE) -C $(SRC_DIR)/boot/bootl BUILD_DIR=$(abspath $(BUILD_DIR))

stage2: $(BUILD_DIR)/boot/ssbootl.bin 

$(BUILD_DIR)/boot/ssbootl.bin: always
	$(MAKE) -C $(SRC_DIR)/boot/ssbootl BUILD_DIR=$(abspath $(BUILD_DIR))

