#ifndef _OS_DISK_
#define _OS_DISK_

#include "type.h"

bool disk_read(u16 disk_number, u32 LBA, u8 sectors_count, u8 far* target);

#endif