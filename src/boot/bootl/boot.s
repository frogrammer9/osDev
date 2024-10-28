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

; Disk Adress Packet Structure
daps:
						db 0x10 ; Size if this struct
						db 0	; Required
daps_sectors_to_read:	dw 0
daps_buffer_offset:		dw 0	; Adress offset
						dw 0	; Adress segment - 0000
daps_LBA_low:			dd 0
						dd 0	; daps_LBA_high - not used

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
	.puts_loop:
	lodsb
	or al, al
	jz .puts_done
	int 0x10
	jmp .puts_loop
	.puts_done:
	pop bx
	pop si
	ret

load_file: ; ax - ptr to string with file name | bx - buffer adress offset (0000:BUFF)

load_cluster: ; ax, bx - LBA | cx - 0000:BUFF | dx - size
	push si
	mov [daps_sectors_to_read], dx
	mov [daps_buffer_offset], cx
	mov [daps_LBA_low], ax
	mov [daps_LBA_low + 2], bx
	mov ah, 0x42
	mov dl, [ebr_drive_number]
	mov si, dap
	int 0x13
	jc .error
	ret

find_file: ; ax - ptr to string with the file name



main:
	mov ah, 0x41
	mov bx, 0x55AA
	mov dl, 0x80
	int 0x13
	jc .benserr ; Bios extenctions not supported error

	push es
	mov ah, 0x8
	mov dl, 0x80
	int 0x13
	jc .error
	pop es
	and cl, 0x3F
	xor ch, ch
	inc dh
	; This i'm getting the disk params from bios in case the disk got corrupted
	mov [bdb_sectors_per_track], cx
	mov [ebr_drive_number], dl
	mov [bdb_head_count], dh

	mov ax, loadingmsg
	call puts

	call hang

.benserr:
	mov ax, benserrmsg
	call puts
	call hang

.error:
	mov ax, errormsg
	call puts
	call hang

hang:
	hlt
	jmp hang 

loadingmsg: db 'Loading...', END
benserrmsg: db 'BENSERR', END
errormsg:	db 'ERROR', END

times 510 - ($ - $$) db 0 
dw 0xAA55
