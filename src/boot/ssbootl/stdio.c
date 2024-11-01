#include "lib/stdio.h"
#include "lib/x86.h"

void puts(cstr str) {
	while(*str) x_write_char_teletype(*(str++), 0);
}

void putc(char c) {
	x_write_char_teletype(c, 0);
}
