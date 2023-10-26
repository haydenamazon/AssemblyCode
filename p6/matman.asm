; Hayden Amazon
; P6
; 10/25/23
; Etc...... . . . .

SECTION .data
; define data/variables here.  Think DB, DW, DD, DQ
ROWS: EQU 5
COLS: EQU 7
;set each instance of ROWS to 5 upon execution
MyMatrix: dd  1,  2,  3,  4,  5,  6,  7
	  dd  8,  9, 10, 11, 12, 13, 14
	  dd 15, 16, 17, 18, 19, 20, 21
	  dd 22, 23, 24, 25, 26, 27, 28
	  dd 29, 30, 31, 32, 33, 34, 35 
	  ;data set 2

;
CurrROW: dd ROWS
CurrCOL: dd COLS

SECTION .bss
; define uninitialized data here
RowSums: RESD ROWS
ColSums: RESD COLS
GrandTotal: RESD 1 ;0

SECTION .text
global _main
_main:

; put your code here.
col_loop:
	dec dword [CurrCOL]

	mov eax, [CurrCOL]
	cmp eax, -1
	jng exit

	;row counter is reset
	mov dword[CurrROW], ROWS

row_loop:
	dec dword [CurrROW]
	mov eax, [CurrROW]

	cmp eax, -1
	jng col_loop
	;similar to col_loop acts to see if the current row is less than 0


	mov eax, [CurrROW]
	mov ebx, COLS
	mul ebx
	
	;adds matrix address
	add eax, [CurrCOL]
	mov edx, MyMatrix

	mov ecx, [edx + eax * 4]
	add dword [GrandTotal], ecx

	;gets the sum of the row and then moves into the next row (the * 4)
	mov eax, [CurrROW]
	mov edx, RowSums
	add [edx + eax * 4], ecx

	;gets the sum of the column and then moves into the next row (the * 4)
	mov eax, [CurrCOL]
	mov edx, ColSums
	add [edx + eax * 4], ecx
	
	;recursive loop that jumps back to the top until the current row is not greater than the column loop
	jmp row_loop

exit:

lastBreak:
; Normal termination code
mov eax, 1
mov ebx, 0
int 80h
