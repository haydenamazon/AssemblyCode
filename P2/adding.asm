; NAME: Hayden Amazon
; Assignment: P2 Adding Integers
; Date: 9/22/23
; Etc...How are you today?

SECTION .data
; define data/variables here.  Think DB, DW, DD, DQ

SECTION .bss
; define uninitialized data here

SECTION .text
global _main
_main:

; put your code here.


mov AX,0CDBAh
mov BX,0CDABh
add AX, BX

mov AX,0ABCDh
mov BX,0ABCDh
add AX, BX

mov AX,0FAFAh
mov BX,00505h
add AX, BX

mov AX,0F0F0h
mov BX,0FF00h
add AX, BX

mov AX,0D468h
mov BX,02B98h
add AX, BX

mov AX,0700Fh
mov BX,00FF1h
add AX, BX

mov AX,01234h
mov BX,07654h
add AX, BX

mov AX,00B0Bh
mov BX,0A11Eh
add AX, BX

mov AX,07654h
mov BX,0789Ah
add AX, BX

mov AX,08000h
mov BX,08000h
add AX, BX


		
		
		
		
		
		
		
		




; Normal termination code
mov eax, 1
mov ebx, 0
int 80h
