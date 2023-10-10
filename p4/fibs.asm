; Hayden Amazon
; p4
; 10/10/23
; Etc......

SECTION .data
; define data/variables here.  Think DB, DW, DD, DQ
	fib db 16
SECTION .bss
; define uninitialized data here
Fibs: RESD 16

SECTION .text
global _main
_main:
	mov eax, Fibs
	;mov Fibs into eax
	mov ebx, 0
	;mov 0 into ebx
	mov [eax], ebx

	add eax, 4
	mov ebx, 1
	mov [eax], ebx

	mov edx, 2
	loop:
	;loop which gets the previous fib num in the ebx (eax - 4) and adds the one prior (eax - 8)
		add eax, 4
		mov ebx, [eax - 4]
		add ebx, [eax - 8]
		mov [eax], ebx
	;loop finished
	inc edx
	cmp edx, dword [fib]
	jnz loop
lastBreak:
; put your code here.



; Normal termination code
mov eax, 1
mov ebx, 0
int 80h
