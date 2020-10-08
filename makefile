NASM=nasm
LD=ld
RUSTC=rustc

all:
	$(NASM) -f elf -o boot.o boot.asm

	$(RUSTC) main.rs -C overflow-checks=no --emit=obj --target=i686-unknown-linux-gnu

	$(LD) -melf_i386 -T linker.ld -o kernel.bin *.o

	rm *.o

	qemu-system-i386 -kernel kernel.bin