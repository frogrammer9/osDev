#include "lib/misc.h"

void fill(u8 far* target, u32 size, u8 value) {
	for(u32 i = 0; i < size; ++i) {
		target[i] = value;
	}
}
