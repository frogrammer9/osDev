#ifndef _OS_STDIO_
#define _OS_STDIO_

#include "stdint.h"

int puts(cstr str);
int putc(char c);

void __cdecl printf(cstr format, ...);

#endif
