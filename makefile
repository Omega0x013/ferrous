NASM=nasm
LD=ld
RUSTC=rustc

all:
	$(NASM) -f elf64 -o boot.o boot.asm

	$(RUSTC) main.rs -C overflow-checks=no --emit=obj

	$(LD) -melf_x86_64 -T linker.ld -o kernel.bin *.o

	rm *.o

	qemu-system-x86_64 -kernel kernel.bin