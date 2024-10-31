ASM?=nasm
SRC_DIR?=src
BUILD_DIR?=build

.PHONY: all clean always

all: stage2

stage2: $(BUILD_DIR)/boot/ssbootl.bin

$(BUILD_DIR)/boot/ssbootl.bin: always
	$(ASM) ssbootl.s -f bin -o $(BUILD_DIR)/boot/ssbootl.bin

clean:
	rm -f $(BUILD_DIR)/boot/ssbootl.bin

always:
	mkdir -p $(BUILD_DIR)/boot
