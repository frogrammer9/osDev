org 0x7C00
bits 16

%define END 0x0D, 0x0A, 0

; FAT12 variables
jmp short init
nop

bpb_OEM_ident:					db 'MSWIN4.1'
bpb_bytes_per_sector:			dw 0x200
bpb_sectors_per_cluster:		db 0x1
bpb_reserved_sectors:			dw 0x1
bpb_FAT_count:					db 0x2
bpb_root_dir_entries_count:		dw 0xE0
bpb_sectors_in_logic_colume:	dw 0xB40
bpb_media_descriptor_type:		db 0xF0
bpb_sectors_per_FAT:			dw 0x9
bpb_sectors_per_track:			dw 0x12
bpb_head_count:					dw 0x2
bpb_hidden_sectors_count:		dd 0x0
bpb_large_sector_count:			dd 0x0

ebr_drive_number:				db 0						; This will be read later by bios int
ebr_windows_flag:				db 0						; Not important
ebr_signature:					db 0x29 					; This just must be this falue
ebr_volumeID:					db 0x12, 0x34, 0x56, 0x78	; This can be set to anything
ebr_volume_label:				db 'OSDEV      '			; Must be 11 chars padded with spaces
ebr_system_ident:				db 'FAT12   '				; Must be 8 chars padded with spaces

db 'X'
DEBUG:	dw 0x70
db 'X'

; Disk Adress Packet Structure
daps:
						db 0x10 ; Size if this struct
						db 0x0	; Required
daps_sectors_to_read:	dw 0x0
daps_buffer_offset:		dw 0x0	; Adress offset
						dw 0x0	; Adress segment - 0000
daps_LBA_low:			dd 0x0
						dd 0x0	; daps_LBA_high - not used

; Setting up data segments
init:
	mov ax, 0
	mov ds, ax
	mov es, ax
	; Setting up stack
	mov ss, ax
	mov sp, 0x7C00
	; Some bioses can load at 07C0:0000 instead of at 0000:7C00
	push es
	push main
	retf


puts: ; ptr to string in ax
	push si
	push bx
	mov si, ax
	mov ah, 0x0e ; putc in TTY mode
	mov bx, 0 ; page number
	cld
	.loop:
	lodsb
	or al, al
	jz .done
	int 0x10
	jmp .loop
	.done:
	pop bx
	pop si
	ret

load_sectors: ; ax - LBA (ds(0):ax) | bx - 0000:BUFF | cx - size
	push si
	push ax
	push dx
	mov [daps + 2], cx
	mov [daps + 4], bx
	mov [daps + 8], ax
	mov ah, 0x42
	mov dl, 0x80
	mov si, daps
	int 0x13
	jc error
	pop dx
	pop ax
	pop si
	ret

find_file: ; ax - ptr to the string with the file name | di - ptr to buffer | returns ax - cluster number (0 if NOT found)
	push bx
	push cx
	push si
	xor bx, bx

	.loop:
	mov cx, 11 ; Compare up to 11 chars
	mov si, ax
	push di
	repe cmpsb
	pop di
	je .found

	add di, 32
	inc bx
	cmp bx, [bpb_root_dir_entries_count]
	jl .loop
	mov ax, 0
	jmp .done
	.found:
	mov ax, di 
	add ax, 26
	.done:
	pop si
	pop cx
	pop bx
	ret

load_file: ; bx - offset target adress | ax - cluster number | cx - Data segment offset
	push dx
	push di
	mov di, cx
	xor dx, dx

	.loop:
	; loading
	push ax
	mul byte [bpb_sectors_per_cluster]
	add ax, di
	xor cx, cx
	mov cl, [bpb_sectors_per_cluster]
	mov [DEBUG], ax
	;call load_sectors

	mov ax, cx
	mul word [bpb_bytes_per_sector]
	add bx, 512

	; Getting the next cluster number
	pop ax
	add ax, 2
	shr ax, 1
	push bx
	jnc .even
	; odd
	mov bx, ax
	add bx, ax
	add bx, ax
	mov ax, BUFF
	add bx, ax
	mov ax, [bx]
	shr ax, 4
	sub ax, 2
	jmp .check
	.even:
	mov bx, ax
	add bx, ax
	add bx, ax
	mov ax, BUFF
	add bx, ax
	mov ax, [bx]
	and ax, 0xfff
	sub ax, 2
	.check:
	pop bx
	xor dx, dx
	cmp ax, 0xff8
	jl .loop

	pop di
	pop dx

	ret


main:
	mov ah, 0x41
	mov bx, 0x55AA
	mov dl, 0x80
	int 0x13
	jc benserr ; Bios extenctions not supported error

	push es
	mov ah, 0x8
	mov dl, 0x80
	int 0x13
	jc error
	pop es
	and cl, 0x3F
	xor ch, ch
	inc dh
	; There i'm getting the disk params from bios in case the disk got corrupted
	mov [bpb_sectors_per_track], cx
	mov [ebr_drive_number], dl
	mov [bpb_head_count], dh	; ERROR POSSIBLE
	; Write "Loading..."
	mov ax, loadingmsg
	call puts
	; Calculate the LBA of the directory entry on the FAT12 disk
	xor ax, ax
	mov al, [bpb_FAT_count]
	mov bx, [bpb_sectors_per_FAT]
	mul bx
	push bx
	mov bx, [bpb_reserved_sectors]
	add bx, ax
	mov si, bx
	; Calculate the size (amount of sectors) of the directory entry
	mov ax, [bpb_root_dir_entries_count]
	shl ax, 5
	xor dx, dx
	div word [bpb_bytes_per_sector]
	mov cx, ax
	add si, cx
	; Loading the directory entry
	mov ax, bx
	mov bx, BUFF
	call load_sectors
	mov ax, filename
	mov di, BUFF
	call find_file
	; check if ax is 0 and errro
	mov bx, ax
	mov ax, [bx]
	sub ax, 2
	mov [cluster_number], ax
	; Load FAT into memory
	mov ax, [bpb_reserved_sectors]
	mov bx, BUFF
	pop cx
	call load_sectors

	mov ax, [cluster_number]
	mov bx, 0x8500	; This is dengeraus and needs to bo changed
	mov cx, si
	call load_file

	mov ax, 0x8500
	call puts

	call hang

benserr:
	mov ax, benserrmsg
	call puts
	call hang

error:
	mov ax, errormsg
	call puts
	call hang

hang:
	hlt
	jmp hang 

loadingmsg:			db 'Loading...', END
benserrmsg: 		db 'BENSERR', END
errormsg:			db 'ERROR', END
filename:			db 'TEST    TXT'
cluster_number:		dw 0

times 510 - ($ - $$) db 0 
dw 0xAA55
BUFF: 
