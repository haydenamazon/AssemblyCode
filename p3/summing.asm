; Hayden Amazon
; CSC322
; 10/2/23
; Assignment

SECTION .data
; define data/variables here.  Think DB, DW, DD, DQ

bArray:		DB		1,-2,3,-4,5
wArray:		DW		100,200,300,400,500
dArray:		DD		-322,-322h,-322q,-1833,-1833h
bArraySum:	DB		0
wArraySum:	DW		0
dArraySum:	DD		0
grandTotal:	DD		0

SECTION .bss
; define uninitialized data here

SECTION .text
global _main
_main:

; put your code here.

;first byte size array
mov al, [bArray]
add al, [bArray + 1]
add al, [bArray + 2]
add al, [bArray + 3]
add al, [bArray + 4]
mov [bArraySum], al

;second word size array
mov ax, [wArray]
add ax, [wArray + 2]
add ax, [wArray + 4]
add ax, [wArray + 6]
add ax, [wArray + 8]
mov [wArraySum], ax

;third dword size array
mov eax, [dArray]
add eax, [dArray + 4]
add eax, [dArray + 8]
add eax, [dArray + 12]
add eax, [dArray + 16]
mov [dArraySum], eax

;grandTotal sum
movsx eax, byte [bArraySum]
add [grandTotal], eax

movsx eax, word [wArraySum]
add [grandTotal], eax

mov eax, dword [dArraySum]
add [grandTotal], eax

lastBreak:
; Normal termination code
mov eax, 1
mov ebx, 0
int 80h
