#ifndef _OS_STDIO_
#define _OS_STDIO_

#include "type.h"

void puts(cstr str);
void putc(char c);

void __cdecl printf(cstr format, ...);

#endif
