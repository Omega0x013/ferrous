bits 32
global start, gdt_code
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