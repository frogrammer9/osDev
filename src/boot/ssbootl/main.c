#include "lib/type.h"
#include "lib/stdio.h"
#include "lib/x86.h"

int __cdecl cmain_(u16 drive_number) {

	printf("halo, %u, %u \n", 12, 12);

	x_hang();
	return 1; // This program should never return
}
