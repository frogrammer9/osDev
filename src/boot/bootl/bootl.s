org 0x7c00
bits 16

start:
	mov [drive_number], dl
	xor ax, ax
	mov ds, ax
	mov es, ax
	mov ss, ax
	mov sp, 0x7c00
	push es
	push entry
	retf

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
	; Initialization, checking if bios extections are supported and filling daps with 0s
	mov ah, 0x41
	mov bx, 0x55aa
	mov dl, [drive_number]
	int 0x13
	jc .benserr ; Bios extenctions not supported
	; Load 2nd stage bootloader into memory
	mov ah, 0x42
	mov dl, [drive_number]
	mov si, daps
	int 0x13
	jc .load_fail

	mov ax, [target_segment]
	mov es, ax
	mov ds, ax
	mov ax, [target_offset]
	mov dl, [drive_number]
	push es
	push ax
	retf

	.benserr:
	mov si, benserrmsg
	call puts
	jmp end

	.load_fail:
	mov si, loadfailmsg
	call puts
	jmp end

end:
	mov si, endmsg
	call puts
	.loop:
	mov ah, 0x0
	int 0x16
	cmp al, '1'
	je .c1
	jmp .loop
	.c1:
	mov ah, 0x0
	int 0x19
	hlt	; Should never happen
	jmp .loop


%define END 0x0d, 0x0a, 0

drive_number:	db 0
benserrmsg:		db 'Enhanced Disk Drive unsupported', END
loadfailmsg:	db 'Failed to load ssbootl', END
endmsg:			db 'Press (1) to reboot', END

daps:
				db 16
				db 0
size:			dw 127
target_offset:	dw 0x0000
target_segment:	dw 0x07e0
				dw 0x04
				dw 0x0
				dd 0x00000000

times 446 - ($ - $$) db 0
; MBR
p1_status:		db 0x80
p1_shead:		db 0x20
p1_ssector:		db 0x21
p1_scylinder:	db 0x00
p1_type:		db 0xdf
p1_lhead:		db 0x61
p1_lsector:		db 0x21
p1_lcylinder:	db 0x0
p1_LBA:			dd 0x00000800
p1_size:		dd 0x00001000

p2_status:		db 0x0
p2_shead:		db 0x61
p2_ssector:		db 0x22
p2_scylinder:	db 0x0
p2_type:		db 0x83
p2_lhead:		db 0x46
p2_lsector:		db 0x5
p2_lcylinder:	db 0x1
p2_LBA:			dd 0x00001800
p2_size:		dd 0x00003800

p3_status:		db 0
p3_shead:		db 0
p3_ssector:		db 0
p3_scylinder:	db 0
p3_type:		db 0
p3_lhead:		db 0
p3_lsector:		db 0
p3_lcylinder:	db 0
p3_LBA:			dd 0
p3_size:		dd 0

p4_status:		db 0
p4_shead:		db 0
p4_ssector:		db 0
p4_scylinder:	db 0
p4_type:		db 0
p4_lhead:		db 0
p4_lsector:		db 0
p4_lcylinder:	db 0
p4_LBA:			dd 0
p4_size:		dd 0

dw 0xaa55
