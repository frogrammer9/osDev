#define far
#include "lib/type.h"
#include "lib/stdio.h"
#include "lib/x86.h"
#include "lib/disk.h"

int __cdecl cmain_(u16 drive_number) {

	printf("SSBOOTL Loading...\r\n");

	u8 sig[4] = {0x58, 0x58, 0x58, 0x58}; // XXXX - so i can find it in ram memdump

	u8 buffer[512];

	disk_read(drive_number, 0, 1, buffer);

	x_hang();
	return 1; // This program should never return
}
