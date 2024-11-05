#ifndef _OS_STDINT_
#define _OS_STDINT_

typedef unsigned char u8;
typedef signed char i8;
typedef unsigned short u16;
typedef signed short i16;
typedef unsigned long int u32;
typedef signed long int i32;
typedef unsigned long long int u64;
typedef signed long long int i64;
typedef float f32;
typedef double f64;

typedef u8 bool;
#define true 1
#define false 0

#define cstr const char*

#define NULL ((void*)0)

#define min(a, b) (((a) < (b)) ? (a) : (b))
#define max(a, b) (((a) > (b)) ? (a) : (b))

#endif
