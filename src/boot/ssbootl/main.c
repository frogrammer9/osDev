#include "lib/stdint.h"
#include "lib/stdio.h"
#include "lib/x86.h"
#include "lib/disk.h"

int __cdecl cmain_(u16 drive_number) {

	printf("SSBOOTL Loading...\r\n");

	u8 buffer[512];

	//printf("Hallo 1\r\n");
	if(disk_read(drive_number, 0, 1, &buffer[0])) {
		printf("zjebało sie\r\n"); // This fails but printf doesnt work
		puts("HALO KURWA\r\n"); // This works just fine c:
		x_hang();
	}
	x_reboot();
	printf("Hallo 2\r\n");

	x_hang();
	return 1; // This program should never return
}
