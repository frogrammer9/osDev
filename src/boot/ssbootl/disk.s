bits 16

global _x_disk_read 
_x_disk_read:
	push bp
	mov bp, sp
	push si

	mov ah, 0x42
	mov dx, [bp + 8]
	mov si, [bp + 10]
	
	int 0x13
	mov ax, 0
	sbb ax, ax
	neg ax

	pop si
	mov sp, bp
	pop bp
	ret
