# Loading and Executing a Baremetal Binary Application Using U-Boot

## Motivation
In hopes of having a firm understanding over concepts like linkers, bootloaders, and compilation process, my Embedded Linux mentor, Eng. Fady Khalil, encouraged my collegues and I to create a simple LED-blink *baremetal* program for the Raspberry Pi 3B+, load it into RAM and execute it via U-Boot. 

## Startup Code
The startup file was written in armv8 64-bit assembly. It simply jumps to the entrypoint aka main function in c code. Additionally, it has an infinite loop at the end just in case the branching into main failed/did not happen: this is crucial to prevent damaging the Raspberry Pi.

```s
/* defining new section for asm code */
.section ".text.asm"
 
 /* make _start a global label */
.global _start

/* simply, jump to main */
_start:
	b	main

/* in case the app tries to return, keep jumping into here infinitely*/
here:
	b here
```

## Main Program
Since my experience in programming SoC's was non-existent, I was quite terrified of this step. But in practice, it was quite similar to the rationale of programming a microcontroller; albeit on a *waaaay* larger scale.

My first instinct was to download the datasheet of the Raspberry Pi 3B+'s SoC: BCM2837. 

The relevant info extracted from the datasheet was as follows:
1. Set alternate function select for GPIO pin 26 to output.
1. Write at the bit corresponding to GPIO pin 26 to set and clear.

The only problem with this datasheet was its sussy register addresses. It turns out the register addresses were for BCM2835 but the registers/their functions were the same as BCM2837. I have found a header file created by Apple that has the right register addresses and used it in my code. The program itself was not complex as you can see below.

```c
#include "BCM2837.h"

#define LED_PIN 26 /* GPIO_PIN_26 (pin number 37 in RPi3B+) */

#define TRUE 0x01 /* macro to make the superloop prettier */

#define FSEL_OUTPUT 0b001 /* each pin has 3 bits in FSEL register for mode selection */

#define DELAY_VAL   0x100000 /* arbitrary delay value */

/* function that causes a delay */
void delay(const unsigned long int duration)
{
    /* defining iterator */
    int iter;

    /* loop for a long time according to the passed duration parameter */
    while (iter < duration)
    {
        /* increment iterator */
        iter++;
    }
}

void main(void)
{    
    /* clear GPIO pin 26 fsel bits */
    (*(volatile unsigned int*)BCM2837_GPFSEL2) &= ~(0b111 << 18); /* write 001 in bit 18,19,20 */

    /* make GPIO pin 26 output */
    (*(volatile unsigned int*)BCM2837_GPFSEL2) |= (FSEL_OUTPUT << 18); /* write 001 in bit 18,19,20 */

    /* superloop goes brrr! */
    while (TRUE)
    {
        /* write 1 to bit 26 to set GPIO26 (HIGH) */
        (*(volatile unsigned int*)BCM2837_GPSET0) |= (1U << LED_PIN);

        /* delay to see a change in LED state */
        delay(DELAY_VAL);

        /* write 1 to bit 26 to clear GPIO26 (LOW) */
        (*(volatile unsigned int*)BCM2837_GPCLR0) |= (1U << LED_PIN);

        /* delay to see a change in LED state */
        delay(DELAY_VAL);
    }
}
```

## Linker Script
The linker script is as simple as it can get. **HOWEVER,** 2 important pieces of info can make or break this project:

1. `ENTRY(_start)` &rarr; The entry label must be the same as specified in the startup assembly code.
1. `.` &rarr; The `.` or the address that the program will loaded into in RAM, MUST be in a valid load address that the Raspberry Pi is able to execute binaries from. I chose to set to `0x0c100000` for reasons I will discuss later.

```ld
ENTRY(_start)
 
SECTIONS
{
    . = 0x0c100000;
    __start = .;
    .text :
    {
        KEEP(*(.text.asm))
        *(.text)
    }
    . = ALIGN(4096);
    .rodata :
    {
        *(.rodata)
    }
    . = ALIGN(4096);
    .data :
    {
        *(.data)
    }
    . = ALIGN(4096);
    __bss_start = .;
    .bss :
    {
        bss = .;
        *(.bss)
    }
    . = ALIGN(4096); 
    __bss_end = .;
    __bss_size = __bss_end - __bss_start;
    __end = .;
}
```

## Makefile
The makefile pretty much combines all the previous files into an executable form. I used `aarch64` compiler to do the job.
```makefile
CROSS_TOOLCHAIN="aarch64-linux-gnu-"

all:
	${CROSS_TOOLCHAIN}as -o start.o ./asm/start.s
	${CROSS_TOOLCHAIN}gcc -c -o main.o ./src/main.c -I ./inc -ffreestanding -O0 -nostdlib -g
	${CROSS_TOOLCHAIN}gcc -T ./ld/linker.ld -o kernel7.elf start.o main.o -ffreestanding -O0 -nostdlib -lgcc -g
	${CROSS_TOOLCHAIN}objcopy kernel7.elf -O binary kernel7.img
	rm *.o

clean:
	rm -f *.img *.elf
```

## Loading Binary into RAM & Executing it via U-Boot
After building the binary, move it to your `boot` partition in sd card then boot into u-boot.

The first thing is to load the app into RAM.
```
fatload mmc 0:1 0x0C100000 blinky.img
```

This address was chosen based on the recommended load address for applications on ARM platforms in U-Boot's datasheet. The exact documentation file is `README.standalone`.
```
4. The default load and start addresses of the applications are as
   follows:

			Load address	Start address
	x86		0x00040000	0x00040000
	PowerPC		0x00040000	0x00040004
	ARM		0x0c100000	0x0c100000
	MIPS		0x80200000	0x80200000
	Blackfin	0x00001000	0x00001000
	Nios II		0x02000000	0x02000000
	RISC-V		0x00600000	0x00600000
```

Alternatively, loading the binary into the **kernel address** which is `0x80000`.

The only thing left to do is just go to the address and execute the binary.

```
go 0x0C100000
```

## Results
See for yourself!
![](./README_Photos/loadapp.jpeg)

## Sources
1. [how-to-compile-armv8-code-for-raspberry-pi-3 --- Stackoverflow](https://stackoverflow.com/questions/55560598/how-to-compile-armv8-code-for-raspberry-pi-3)
1. [Raspberry Pi C/C++ Baremetal Programming | Using C to Direct-Register Control Your Raspberry Pi --- Low Level Learning](https://www.youtube.com/watch?v=mshVdGlGwBs&t=337s)
1. [U-Boot Documentation](https://github.com/u-boot/u-boot)
1. [BCM2837 Datasheet Issue --- Github](https://github.com/raspberrypi/documentation/issues/325)