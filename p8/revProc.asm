; Hayden Amazon
; p8
; NOVEMBER 8th
; Etc......

SECTION .data
; define data/variables here.  Think DB, DW, DD, DQ
array1: dd      1,2,3,4,5
len1:   EQU     ($-array1)/4


array2: dd      -10, -9,-8,-7,-6,-5,-4,-3,-2,-1,0,1,2,3,4,5,6,7,8,9
len2:   EQU     ($-array2)/4


array3: dd  0,10,20,30,40,50,60,70,80,90
	  dd  100,110,120,130,140,150,160,170,180,190
	  dd  200,210,220,230,240,250,260,270,280,290
	  dd  300,310,320,330,340,350,360,370,380,390
	  dd  400,410,420,430,440,450,460,470,480,490,500
len3:   EQU     ($-array3)/4

SECTION .bss
; define uninitialized data here

SECTION .text
global _main
_main:
;;;;;;;;;
;;;;;;;;;
;;;;;;;;;
;each array will be ran at a different break. Array1 will run default, Array2 after break 2, Array3 after break3
	mov eax, array1
	mov ebx,len1
	call reverse
breakarray2:
	mov eax, array2
	mov ebx, len2
	call reverse
breakarray3:
	mov eax, array3
	mov ebx, len3
	call reverse
lastBreak:
; put your code here.



; Normal termination code
mov eax, 1
mov ebx, 0
int 80h

reverse:
	xor esi, esi
	;zero out the esi register
	xor edi, edi
	;zero out the edi register
	
	push:
		cmp esi, ebx
	;compare esi to the len of the array in the ebx reg
		jge pop
	;if larger than the len array jump to pop
		mov edx, DWORD [eax + esi * 4]
		push edx
		inc esi
		jmp push
	pop:
		cmp edi, ebx
	;similar to push but uses edi register rather than esi
		jge done
	;exit the loop
		pop edx
		mov DWORD [eax + edi * 4], edx
		inc edi
		jmp pop
	done:
		mov esi, 0
		mov edi, 0
	;
ret
