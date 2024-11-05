#ifndef _OS_X86_
#define _OS_X86_

#include "type.h"

typedef struct {
	u8 size;
	u8 reserved;
	u16 count;
	u8 far* target;
	u64 LBA;

} daps;

void __cdecl x_write_char_teletype(char c, u8 page);

u16 __cdecl x_disk_read(u16 drive_number, daps* d); // Returns 1 if fails

void __cdecl x_div_64_32(u64 divident, u32 divisor, u64* quotientOut, u32* remainderOut);

void __cdecl x_hang();
void __cdecl x_reboot();

#endif
