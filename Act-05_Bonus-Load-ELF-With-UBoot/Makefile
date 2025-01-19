CROSS_TOOLCHAIN="aarch64-linux-gnu-"

all:
	${CROSS_TOOLCHAIN}as -o start.o ./asm/start.s
	${CROSS_TOOLCHAIN}gcc -c -o main.o ./src/main.c -I ./inc -ffreestanding -O0 -nostdlib -g
	${CROSS_TOOLCHAIN}gcc -T ./ld/linker.ld -o kernel7.elf start.o main.o -ffreestanding -O0 -nostdlib -lgcc -g
	${CROSS_TOOLCHAIN}objcopy kernel7.elf -O binary kernel7.img
	rm *.o

clean:
	rm -f *.img *.elf
