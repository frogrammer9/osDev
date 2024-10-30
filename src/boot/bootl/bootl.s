org 0x7C00
bits 16

; The disk for this bootloader must be FAT32 with the sector size of 512, 1 sector per cluster and 131050 clusters
; The values are hardcoded for now bcoz i dont really get how the FAT header plays with a bootloader

%define CLUSTER_SIZE	0x200
%define FAT_LBA			0x20
%define FAT_SIZE		0x7e0	; In sectors
%define DATA_LBA		0x800

jmp short start
nop
								db 'MSWIN4.1'
bpb_bytes_per_sector:			dw 0x200
bpb_sectors_per_cluster:		db 0x1
bpb_reserved_sectors:			dw 0x20
bpb_FAT_count:					db 0x2
bpb_root_dir_entries_count:		dw 0x0
bpb_sectors_in_logic_colume:	dw 0x0
bpb_media_descriptor_type:		db 0xF8
								dw 0x0
bpb_sectors_per_track:			dw 0x20
bpb_head_count:					dw 0x8
bpb_hidden_sectors_count:		dd 0x0
bpb_large_sector_count:			dd 0x1FFE0

ebr_sectors_per_FAT:			dd 0x3F0
ebr_flags:						dw 0
ebr_FATV:						dw 0
ebr_root_cluster_number:		dd 0x2
ebr_FInfo_sector_number:		dw 0x100
ebr_backup_boot_sector_number:	dw 0x6
								times 12 db 0
ebr_drive_number:				db 0x80
								db 0
ebr_signature:					db 0x29
ebr_volume_id:					db 0x12, 0x34, 0x56, 0x78
								db 'OSDEV      '	; Must be 11 chars
								db 'FAT32   '		; Must be this value 

start:
	xor ax, ax
	mov ds, ax
	mov es, ax
	mov ss, ax
	mov sp, 0x7C00
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

load_sectors: ; dx:ax - LBA | es:cx - adress | si - amount of sectors | CF set if fail
	push dx
	mov [daps + 2], si
	mov [daps + 4], cx
	mov [daps + 6], es
	mov [daps + 8], ax
	mov [daps + 10], ax
	mov ah, 0x42
	mov dl, [ebr_drive_number]
	mov si, daps
	int 0x13
	pop dx
	ret

load_file: ; es:cx - adress 
	xor dx, dx

	.loop:
	mov ax, DATA_LBA
	add ax, [cluster_number]
	sub ax, 2
	mov si, CLUSTER_SIZE
	mul si

entry:
	; Initialization, checking if bios extections are supported and filling daps with 0s
	mov ah, 0x41
	mov bx, 0x55AA
	mov dl, [ebr_drive_number]
	int 0x13
	jc .benserr ; Bios extenctions not supported
	mov cx, 16
	mov di, daps
	.init_daps:
	mov byte [di], 0
	inc di
	loop .init_daps
	mov byte [daps], 16

	; Load root directory into buffer
	
	

	jmp hang

	.benserr:
	mov si, benserrmsg
	call puts
	jmp hang



hang:
	hlt
	jmp hang

%define END 0x0D, 0x0A, 0

benserrmsg: db 'BENSERR' , END
filename: db 'TEST    TXT' ; File name of the file to be loaded (must be 11 chars (8 for name and 3 for extenction))

times 510 - ($ - $$) db 0
dw 0xAA55
daps:
times 16 db 0
buffer:
