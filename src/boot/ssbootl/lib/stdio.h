#ifndef _OS_STDIO_
#define _OS_STDIO_

#include "type.h"

int puts(cstr str);
int putc(char c);

void __cdecl printf(cstr format, ...);

#endif
