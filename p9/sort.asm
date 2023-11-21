; Hayden Amazon
; P9
; November 17, 2023
; Etc....

%macro prt 2
    pusha
    mov eax, 4
    mov ebx, 1
    mov ecx, %1
    mov edx, %2
    int 80h
    popa
%endmacro
;first macro with two conditions

%macro prtArray 2
    pusha
    mov edi, %2     ;set edi to numslen
    xor esi, esi    ;clear esi for use as counter
    mov ax, [%1]    ;set ax to nums address in memory
    mov ebx, %1
    call prtArrayLoop
    popa
%endmacro
;macro to print array

; bubble sort
%macro sortArray 2
        pusha
        ;;;;
        mov ecx, %2
        outer:
                mov ebx, 0
		;reset ebx
                inner:
                        mov eax, [%1 + ebx * 2]
                        cmp eax, [%1 + ebx * 2 + 2]
                        jle noSwap
                        mov edx, [%1 + ebx * 2]
                        mov [%1 + ebx * 2], eax
                        mov [%1 + ebx * 2 + 2], edx
		noSwap:
                        inc ebx
			;increment to next element
                        cmp ebx, ecx 
			;looks to see if inner loop is completed
                        jl inner
                        dec ecx
			;decrement counter
                        jnz outer
        popa
%endmacro

SECTION .data
; define data/variables here.  Think DB, DW, DD, DQ
nums:	dw	 2000, 3000, 0, 65535, 0, 1, 2, 3, 100
numslen:	EQU	($-nums) / 2
counts DW 1000

; String place holder
string:  dw "     ", 10, 0

cls:     db 1bh, '[2J'
clsLen:  EQU ($-cls)
;clear

; New Line
nl:     db 10
nlLen:  EQU  ($-nl)

mes1:    db "****Amazon's Array Sorting Program****"
mes1Len: EQU ($-mes1)
mes2:    db "Original Array"
mes2Len: EQU ($-mes2)
mes3:    db "Sorted Array"
mes3Len: EQU ($-mes3)

SECTION .bss
; define uninitialized data here

SECTION .text
global _main
_main:

; put your code here.
prt cls, clsLen       ; clear the screen
prt cls, clsLen
prt nl, nlLen         ; print new line

prt mes1, mes1Len     ; print the title of the program
prt nl, nlLen         ; print new line

prt mes2, mes2Len     ; print the header "Original array"
prt nl, nlLen         ; print new line

;;;;
prtArray nums, numslen          ; prtArray function
sortArray nums, numslen

prt mes3, mes3Len     ; print the header "Sorted array"
prt nl, nlLen         ; print new line

lastBreak:
; Normal termination code
mov eax, 1
mov ebx, 0
int 80h

prtArrayLoop:
    cmp esi, edi            ;check if out of bounds
    jge exitLoop            ;if not OOB, continue

    push edi              
    push ebx

    mov edi, string         ;set edi to string address
    call intToStr           ;call to conversion function
    prt string, 14

    pop ebx
    pop edi                 ;restore counter

    add esi, 2              ;increment counter
    mov ax, WORD[esi + ebx]
DEBUG:
    jmp prtArrayLoop

    exitLoop:
ret



intToStr:
        push ecx
        push ebx
        ;;;;
        mov bl, 10
        add edi, 4
	;;;;
        convert:
                xor edx, edx
		;zero out edx
                ;shr bl
		div bl
                add ah, '0'
                mov [edi], ah
                dec edi        
                xor ah, ah
		;zer out ah
                cmp ax, 0
		;checks if quotient is zero
                jne convert
        ;;;;
        pop ecx
        pop ebx
ret

