bits 16

section _ENTRY class=CODE

extern _cmain_
global entry

entry:
	cli
	mov ax, ds
	sub ax, 0x20 ; Move the stack before the boot partition to keeb the MBR in memory
	mov ss, ax
	mov sp, 0
	mov bp, sp
	sli

	xor dh, dh
	push dx
	call _cmain_

	cli
	hlt

