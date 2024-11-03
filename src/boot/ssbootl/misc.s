bits 16

section _TEXT class=CODE 

global _x_div_64_32
_x_div_64_32:
	push bp
	mov bp, sp
    push bx

    mov eax, [bp + 8]
    mov ecx, [bp + 12]
    xor edx, edx
    div ecx

    mov bx, [bp + 16]
    mov [bx + 4], eax

    mov eax, [bp + 4]
    div ecx

    mov [bx], eax
    mov bx, [bp + 18]
    mov [bx], edx

    pop bx
	mov sp, bp
    pop bp
    ret

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
