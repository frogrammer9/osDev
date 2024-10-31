org 0x0000
bits 16

jmp entry

puts: ; si - ptr to string
	push ax
	push bx
	mov ah, 0xe
	mov bx, 0x0
	cld
	.loop:
	lodsb
	or al, al
	jz .done
	int 0x10
	jmp .loop
	.done:
	pop bx
	pop ax
	ret

entry:
	mov si, testmsg
	call puts
	jmp hang

hang:
	hlt
	jmp hang

%define END 0x0D, 0x0A, 0
testmsg:	db 'ssbootl is loading fuck yeah', END

