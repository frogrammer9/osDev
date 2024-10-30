ASM?=nasm
SRC_DIR?=src
BUILD_DIR?=build

.PHONY: all clean always

all: stage1

stage1: $(BUILD_DIR)/boot/bootl.bin

$(BUILD_DIR)/boot/bootl.bin: always
	$(ASM) bootl.s -f bin -o $(BUILD_DIR)/boot/bootl.bin

clean:
	rm -f $(BUILD_DIR)/boot/bootl.bin

always:
	mkdir -p $(BUILD_DIR)/boot
