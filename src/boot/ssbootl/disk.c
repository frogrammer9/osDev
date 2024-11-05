#include "lib/x86.h"
#include "lib/disk.h"

bool disk_read(u16 disk_number, u32 LBA, u8 sectors_count, u8 far* target) {
	daps D;
	D.size = 16;	// Those two variables must always be set to those exact numbers
	D.reserved = 0;
	D.count = sectors_count;
	D.LBA = LBA;
	D.target = target;
	return x_disk_read(disk_number, &D);
}
