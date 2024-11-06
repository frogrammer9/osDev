#include "lib/stdint.h"
#include "lib/stdio.h"
#include "lib/x86.h"
#include "lib/disk.h"
#include "lib/misc.h"

int __cdecl cmain_(u16 drive_number) {

	printf("SSBOOTL Loading...\r\n");

	const char * test = "HAHAHAHA";

	printf("Test: %s\r\n", test);
	printf("HALO\r\n");


	x_hang();
	return 1; // This program should never return
}
