.global _start

.section .text
_start:
    mov x8, #462          // System call number
    mov x0, #0           // First argument (can be any value)
    svc #0                // Make the system call

    // Exit the program
    mov x8, #93           // Syscall ID for exit()
    mov x0, #0            // Exit status 0
    svc #0
