bits 16

section _TEXT class=CODE 

global _x_write_char_teletype
_x_write_char_teletype:
	push bp
	mov bp, sp
	push bx

	mov ah, 0xe
	mov al, [bp + 4]
	mov bh, [bp + 6]
	int 0x10

	pop bx
	mov sp, bp
	pop bp
	ret
