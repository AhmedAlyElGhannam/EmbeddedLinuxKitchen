# Creating an ARM64 Systemcall

## Introduction
This was an optional task but I decided to do it and I could not be more happy that I invested time into it. Since it would be too easy to do it on ARM32 since I would just be following the demonstration given to me, I decided to do it on ARM64 to pose a bit of a challenge and learn something new along the way.

## Editing The Linux Kernel
1. In `arch/arm64/include/asm/unistd32.h` (for 32-bit compatible system), add the following lines. A systemcall is defined as a macro with the prefix `__NR_` plus the systemcall name. Then, use the macro `__SYSCALL` to link the system call with its handler.
	```c
	/* ADDED BY ME */
	#define __NR_heed_my_call 462 
	__SYSCALL(__NR_heed_my_call, sys_heed_my_call)
	/* ADDED BY ME */
	```
1. In `arch/arm64/include/asm/unistd.h` (for 64-bit dependency), add the following lines. A systemcall is defined as a macro with the prefix `__NR_` plus the systemcall name. Then, use the macro `__SYSCALL` to link the system call with its handler.
	```c
	/* ADDED BY ME */
	#define __NR_heed_my_call 462 
	__SYSCALL(__NR_heed_my_call, sys_heed_my_call)
	/* ADDED BY ME */
	```

1. In `linux/kernel/fork.c`, add the systemcall implementation `SYSCALL_DEFINE0` dictates that the systemcall takes zero arguments. It must have the name of the call handler name passed to it. The function `pr_info` simply prints the string passed to it in kernel logs once the systemcall is invoked.
	```c
	/* ADDED BY ME */
	SYSCALL_DEFINE0(heed_my_call)
	{
		//printk("Heed my call!\n");
		pr_info("Heed my call!\nYour call has been answered!\n");
		return 0;
	}
	/* ADDED BY ME */
	```
1. In `linux/include/uapi/asm-generic/unistd.h`, **MODIFY LINE 846**; add 1 to num of syscalls to prevent out-of-bounds indexing. This macro represent the number of defined systemcalls in the kernel and, since I have just added one, the size must also be incremented.
	```c
	#define __NR_syscalls 463 // was 462
	```
1. In `linux/include/linux/fork.h`, add this line outside of any `#if`. This line represents the systemcall's prototype and `asmlinkage` macro allows it to be called via assembly.
	```c
	/* ADDED BY ME */
	asmlinkage long sys_heed_my_call(void);
	/* ADDED BY ME */
	```

## Compile The Kernel
Simply, build the kernel again for the Raspberry Pi 3B+. Here, I assume you have already configured it for the Pi previously. So, you simply need to call make.
```bash
time make -j12 Image dtbs ARCH=arm64 CROSS_COMPILE=aarch64-rpi3-linux-gnu-
```

## Creating an App To Invoke Added Systemcall
I have created a very simple assembly program that invokes the systemcall I have created. In ARM64, a system call is invoked by putting its number in the register `x8`, putting the arguments to registers `x0`, `x1`, `x2`, `x3`; then executing the command `svc` which switches to supervisor mode to handle the systemcall.
```assembly
mov x8, #462          // System call number
mov x0, #0           // First argument (can be any value)
svc #0
```

I then build it using the `Makefile` I have created:
```bash
make all
```

## Testing The Systemcall
Create a `.cpio` file that only contains the binary and put it into your sd card. Then edit `extlinux.conf` to make the init process the name of the binary. 

## Results
See for yourself! :)
![](./README_Photos/call-was-answered.png)