;Hayden Amazon
;p10
;12/13/23
;Etc............


%macro Open 1
	;;;;
        pusha
        mov     eax,5
        mov     ebx,fileName
        mov     ecx,%1
        int     80h
        mov     [fileDescriptor],eax
        popa
	;;;;
%endmacro

%macro Read 3
        pusha
        mov     eax,3 ;sys read
        mov     ebx,[%1]
        mov     ecx,%2
        mov     edx,%3
        int     80h
        popa
%endmacro

%macro Write 3
        pusha
        mov     eax,4
        mov     ebx,[%1]
        mov     ecx,%2
        mov     edx,%3
	;3 parameters in write macro
        int     80h
        popa
%endmacro

%macro Close 0
        pusha
        mov     eax,6
        mov     ebx,[fileDescriptor]
        int     80h
        popa
%endmacro

%macro NormalTermination 0
        mov eax, 1
        mov ebx, 0
        int 80h
%endmacro

%macro clearScreen 0
        pusha
        mov eax, 4
        mov ebx, 1
        mov ecx, cls
        mov edx, [clsLen]
        int 80h
        popa
%endmacro

%macro prt 2
        pusha
        mov ecx, %1
        mov edx, %2
        mov eax, 4
        mov ebx, 1
        int 80h
        popa
%endmacro

%macro convert 0
        push ebx
        push ecx
        xor ebx, ebx
        xor ecx, ecx
        mov bx, '00'
        xchg ah, al
        sub ax, bx
        mov ch, ah
        shl ah, 3
        shl ch, 1
        add ah, ch
        add al, ah
        xor ah,ah
        pop ecx
        pop ebx
%endmacro

%macro convert_back 0
        push ebx
        push ecx        

        mov bl, 10
        div bl
        add ah, 48
        add al, 48

        pop ecx
        pop ebx
%endmacro 

SECTION .data
; define data/variables here.  Think DB, DW, DD, DQ

stdin   dd      0
stdout  dd      1
sec:    dd 1,0
fileName:       db      './file.txt',0
fileDescriptor: dd      0

python: db      1bh,'[02;40H@'
        db      1bh,'[02;41H*'
        db      1bh,'[02;42H*'
        db      1bh,'[02;43H*'
        db      1bh,'[02;44H*'
        db      1bh,'[02;45H*'
        db      1bh,'[02;46H+'
        db      1bh,'[02;47H '
pythonSize:  EQU  $-python
segmentSize : dw 9

screen: db      "********************************************************************************",0ah
        db      "*                          *                           *                       *",0ah
        db      "*      *************       *        *************      *       *********       *",0ah
        db      "*                          *                           *                       *",0ah
        db      "*                          *                           *                       *",0ah
        db      "*                          *                           *                       *",0ah
        db      "*                                                                              *",0ah
        db      "*           **************************        ***********************          *",0ah
        db      "*                                *               *                             *",0ah
        db      "*                                *     ***********                             *",0ah
        db      "*                          *     *               *     *                       *",0ah
        db      "*                          *     **********      *     *                       *",0ah
        db      "*                          *     *               *     *                       *",0ah
        db      "*                          *     *      **********     *                       *",0ah
        db      "*                          *                           *                       *",0ah
        db      "*                                                                              *",0ah
        db      "*           ***   ***   ***   ***   ***   ***   ***   ***   ***   ***          *",0ah
        db      "*                                                                              *",0ah
        db      "*            *     *     *     *     *     *     *     *     *     *           *",0ah
        db      "*               *     *     *     *     *     *     *     *     *              *",0ah
        db      "*            *     *     *     *     *  W  *     *     *     *     *           *",0ah
        db      "*               *     *     *     *     *     *     *     *     *              *",0ah
        db      "*            *     *     *     *     *     *     *     *     *     *           *",0ah
        db      "*               *     *     *     *     *     *     *     *     *              *",0ah
        db      "********************************************************************************",0ah
screenSize:     EQU $-screen

col: dw 1
row: dw 1
segmen: dw 0
termination: dw 0
gameOver: db    "*  G A M E         O V E R  *", 0ah          
gameOverSize: EQU $-gameOver

;Winning screen
gameWin:  db    "*  Y O U      W I N!  *", 0ah
gameWinSize: EQU $-gameWin

;Clear screen
cls     db     1bh, '[2J'
clsLen  dd $-cls

;Cursor position
pos1    db      1bh, '['
        db      '00'
        db      ';'
        db      '00'
        db      'H'

SECTION .bss
; define uninitialized data here

LEN     equ     1024
inputBuffer     RESB LEN
childPID        RESD 1

SECTION .text
global _main, _sleep1
_main:

        lastBreak:
        
        xor ebx, ebx
        xor eax, eax
        mov     eax,2
        int     80h

        cmp     eax,0
        je      childProc
        mov     [childPID],eax
parent:
	;parent
        cmp word [termination], 1
        je lossscreen
        cmp word [termination], 2
        je winscreen

        clearScreen
        call writeToScreen
        call    _getCode
        Write stdout, inputBuffer, 1
        cmp     al,'w'
        je moveUp

        cmp     al,'a'
        je moveLeft

        cmp     al,'s'
        je moveDown

        cmp     al,'d'
        je moveRight

        cmp     al,'q'
        je      ENDgame
        
        clearScreen
        ; sleep one second
time2sleep:
        call _sleep1
        jmp parent

childProc:
	;child
        Read stdin, inputBuffer, LEN

        ;; Open a file for communication
        Open 101h  ; for writing

        ;write to txt file
        Write fileDescriptor, inputBuffer, 1

        ;;;  close the file
        Close

        jmp childProc

; Normal termination code
ENDgame:
        mov     eax,37
        mov     ebx,[childPID]
        mov     ecx,9  ; kill signal
        int     80h
        NormalTermination

winscreen:
        mov     eax,37
        mov     ebx,[childPID]
        mov     ecx,9  ; kill signal
        int     80h
        prt gameWin, gameWinSize
        NormalTermination
lossscreen:
        mov     eax,37
        mov     ebx,[childPID]
        mov     ecx,9  ; kill signal
        int     80h
        prt gameOver, gameOverSize
        NormalTermination


moveLeft:       
	;left movement
        mov ax, [python + 5]
        convert
        mov bx, 1
        sub ax, bx
        convert_back
        call pyshift
        mov [python + 5], ax

        jmp time2sleep

moveRight:            
	;right movement        
        mov ax, [python + 5]
        convert
        mov bx, 1
        add ax, bx
        convert_back
        call pyshift
        mov [python + 5], ax

        jmp time2sleep

moveUp:                 
	;up movement
        mov ax, [python + 2]
        convert
        mov bx, 1
        sub ax, bx
        convert_back
        call pyshift
        mov [python + 2], ax

        jmp time2sleep

moveDown:             
	;down movement
        mov ax, [python + 2]
        convert
        mov bx, 1
        add ax, bx
        convert_back
        call pyshift
        mov [python + 2], ax

        jmp time2sleep

_getCode:
        Open 0  ; readonly
        Read        fileDescriptor, inputBuffer, 2
        Close
        mov     al, BYTE [inputBuffer]
        ret

;;; Sleep function
_sleep1:
        pusha

        mov     eax,162
        mov     ebx,sec
        mov     ecx,0
        int     80h
        popa
        ret

; Normal termination code
mov eax, 1
mov ebx, 0
int 80h

writeToScreen: 
        pusha
        mov eax, screen
        mov ecx, screenSize
topscreen:
	;top screen
        call printsegmen
        cmp word [segmen], 1
        je middlescreen
        prt eax, 1
        jmp middlescreen2
middlescreen:
	;middle screen
        cmp byte [eax], 42d
        je terminator1
        cmp byte [eax], 87d
        je terminator2
        jmp middlescreen2
terminator1:
        mov word [termination], 1
        jmp middlescreen2
terminator2:
        mov word [termination], 2
        jmp middlescreen2
middlescreen2:
	;middle screen
        mov word [segmen], 0
        add eax, 1
        inc word [col]
        cmp word [col], 81
        jne bottomscreen
        inc word [row]
        mov word [col], 0

bottomscreen: 
	;bottom screen
        loop topscreen
        popa
        mov word [col], 1
        mov word [row], 1
        ret

printsegmen: 
	;print segmen
        pusha
        mov ecx, 8      
        mov ebx, python

topsegmen:
	;top segmen
        mov ax, [ebx + 2]
        convert
        cmp ax, [row]
        jne botsegmen
        mov ax, [ebx + 5]
        convert
        cmp ax, [col]
        jne botsegmen
        add ebx, 8
        prt ebx, 1
        sub ebx, 8
        inc word [segmen]

botsegmen:
	;bottom segmen
        add ebx, 9
        loop topsegmen
        popa
        ret

pyshift: 
	;moves python
        pusha
        mov ecx, 7
        mov ebx, python
        add ebx, 63

toshift: 
	;shifts top
        sub ebx, 9
        mov ax, [ebx + 2]
        mov dx, [ebx + 5]
        add ebx, 9
        mov [ebx + 2], ax
        mov [ebx + 5], dx
        sub ebx, 9
        loop toshift
        popa
        ret
