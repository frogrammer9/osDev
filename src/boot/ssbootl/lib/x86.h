#ifndef _OS_X86_
#define _OS_X86_

#include "type.h"

void __cdecl x_write_char_teletype(char c, u8 page);
void __cdecl x_hang();
void __cdecl x_reboot();

#endif
