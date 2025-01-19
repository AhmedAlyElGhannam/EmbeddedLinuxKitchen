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