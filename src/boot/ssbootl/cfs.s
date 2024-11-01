bits 16

section _TEXT class=CODE 

global _x_hang
_x_hang:
	cli
	hlt
	jmp _x_hang

global _x_reboot
_x_reboot:
	mov ah, 0x0
	int 0x19
	hlt ; Should never happen
	jmp _x_reboot
