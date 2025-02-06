
Add this in linux/arch/arm/tools/syscall.tbl (32-bit only)

449 common  heed_my_call        sys_heed_my_call

arch/arm64/include/asm/unistd32.h (for 32-bit compatible system)
/* ADDED BY ME */
#define __NR_heed_my_call 462 
__SYSCALL(__NR_heed_my_call, sys_heed_my_call)
/* ADDED BY ME */

arch/arm64/include/asm/unistd.h (for 64-bit dependency)
/* ADDED BY ME */
#define __NR_heed_my_call 462 
__SYSCALL(__NR_heed_my_call, sys_heed_my_call)
/* ADDED BY ME */

/* ADDED BY ME */
#define __NR_heed_my_call1 402
__SYSCALL(__NR_heed_my_call1, sys_heed_my_call1)
/* ADDED BY ME */

Add this in linux/kernel/sys.c

/* ADDED BY ME */
SYSCALL_DEFINE0(heed_my_call)
{
	//printk("Heed my call!\n");
	pr_info("Heed my call!\nYour call has been answered!\n");
	return 0;
}
/* ADDED BY ME */

SYSCALL_DEFINE0 takes zero arguments and must have the name of the call handler passed to it


linux/include/uapi/asm-generic/unistd.h MODIFY LINE 846 (add 1 to num of syscalls to prevent out-of-bounds indexing)
#define __NR_syscalls 463


linux/include/linux/syscalls.h (add this line outside of any #if)
/* ADDED BY ME */
asmlinkage long sys_heed_my_call(void);
/* ADDED BY ME */
