; Hayden
; P5
; 10/15/23
; Etc... ... 

SECTION .data
; define data/variables here.  Think DB, DW, DD, DQ
Fibs: DD 0
SECTION .bss
; define uninitialized data here
MaxFib: RESD 1
FibCount: RESW 1

SECTION .text
global _main
_main:

mov word [FibCount], 0
mov dword [MaxFib], 1

loop:
	inc dword [FibCount]
	;increases FibCount for every instance in the loop
	mov ecx, [Fibs]
	mov edx, [MaxFib]
	add ecx, edx
	jc end
	;if there is a carry loop ends, else it continues

	mov [Fibs], edx
	mov [MaxFib], ecx

	inc bx
	cmp bx, 75
	jle loop
end:
	mov edx, [Fibs]
	mov [MaxFib], edx
lastBreak:



; put your code here.



; Normal termination code
mov eax, 1
mov ebx, 0
int 80h
