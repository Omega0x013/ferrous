bits 32
global start, putc, clear_video
extern main        ; Allow main() to be called from the assembly code
extern start_ctors, end_ctors, start_dtors, end_dtors
 
MODULEALIGN        equ        1<<0
MEMINFO            equ        1<<1
FLAGS              equ        MODULEALIGN | MEMINFO
MAGIC              equ        0x1BADB002
CHECKSUM           equ        -(MAGIC + FLAGS)
 
section .text      ; Next is the Grub Multiboot Header
 
align 4
MultiBootHeader:
	   dd MAGIC
	   dd FLAGS
	   dd CHECKSUM
 
STACKSIZE equ 0x4000  ; 16 KiB if you're wondering
 
static_ctors_loop:
   mov ebx, start_ctors
   jmp .test
.body:
   call [ebx]
   add ebx,4
.test:
   cmp ebx, end_ctors
   jb .body
 
start:

	mov esp, STACKSIZE+stack

	lgdt [gdt_pointer]
	mov eax, cr0
	or eax,0x1
	mov cr0, eax
	mov eax, DATA_SEG
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov ss, ax
	
	push eax
	push ebx

	; mov dword [0xb8000], 0x07690748

	pushf
	push eax
	push edx
 
	mov dx, 0x3D4
	mov al, 0xA	; low cursor shape register
	out dx, al
 
	inc dx
	mov al, 0x20	; bits 6-7 unused, bit 5 disables the cursor, bits 0-4 control the cursor shape
	out dx, al
 
	pop edx
	pop eax
	popf

	; call clear_video
	call main
 
static_dtors_loop:
   mov ebx, start_dtors
   jmp .test
.body:
   call [ebx]
   add ebx,4
.test:
   cmp ebx, end_dtors
   jb .body
 
 
cpuhalt:
	   hlt
	   jmp cpuhalt

; void putc(character: u8, offset: u32)
putc:
	mov al, [ebp+4]
	mov ebx, [ebp+8]
	shl ebx, 1
	add ebx, 0xb8000
	mov byte [ebx], al
	ret
	
clear_video:
	mov eax, 0xb8000
	mov ebx, 0x1F420F41
	mov ecx, 0x3F442F43
clear_video_loop:
	mov dword [eax], ebx
	add eax, 4
	mov dword [eax], ecx
	add eax, 4
	cmp eax, 0xb8FFFF
	jle clear_video_loop
	ret

section .bss
align 32
 
stack:
	  resb      STACKSIZE

section .data
gdt_start:
	dq 0x0
gdt_code:
	dw 0xFFFF
	dw 0x0
	db 0x0
	db 10011010b
	db 11001111b
	db 0x0
gdt_data:
	dw 0xFFFF
	dw 0x0
	db 0x0
	db 10010010b
	db 11001111b
	db 0x0
gdt_end:
gdt_pointer:
	dw gdt_end - gdt_start
	dd gdt_start

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start
