; Declare some external functions
extern	printf		; the C function, to be called

SECTION .data		; Data section, initialized variables

a:	db	10		; int a=10;
b:	db	27		; int b=27;
c:	db	00000101b ; binary 101(2) == 3(10);

sum: db 0 
dif: dw 0
prd: dw 1
ost: db 0; ostatok
qtn: db 0; chastnoe

outstr:    db "a=%d, b=%d, sum=%d, dif=%d, prd=%d, qnt=%d, ost=%d", 10, 0 ; format string, "\n",'0'

SECTION .text                   ; Code section.

global main		; the standard gcc entry point
main:				; the program label for the entry point
    push    ebp		; set up stack frame
    mov     ebp,esp
    ;sum
    mov eax, 0
	mov	al, [a]	 ; put a from mem into register
    add	al, [b]	 ; a+b
    mov [sum], al ; put to sum(in mem) from register
    
    ;diff
    mov eax, 0
    mov ax, [a]
    sub ax, [b]
    mov [dif], ax

    ;diff with neg
    mov eax, 0
    mov ebx, 0
    mov ax, [a]
    mov bx, [b]
    neg bx
    sub ax, bx
    mov [dif], ax

    ;multiply with sign
    mov eax, 0
    mov al, [b]
    neg al
    imul byte[a]
    mov [prd], ax

    ;multiply without sign
    mov eax, 0
    mov al, [b]
    neg al
    mul byte[a]
    mov [prd], ax

    ;div
    mov eax, 0
    mov ax, [b]
    div byte[a]
    mov [ost], ah
    mov [qtn], al

    ;other task
    mov al, [qtn]
    or al, 11000000b; add 7,8 bits
    and al, 10111100b; del 1,2,7 bits

    ;mod2
    mov bl, al
    xor al, bl

    ;console out

    ;push to stack
    ;revers push arguments because stack

    mov eax, 0

    mov al, [ost]
    push eax

    mov al, [qtn]
    push eax

    mov eax, 0

    mov ax, [prd]
    push eax

    mov ax, [dif]; push value of variable dif
    push   	eax;

    mov eax, 0

    mov al, [sum]; push value of variable sum
    push   	eax;

    mov al, [b]; push value of variable b
    push   	eax;

    mov al, [a]; push value of variable a
    push   	eax; 
    
    push    dword outstr	; address of format string
    call    printf		; Call C function
    add     esp, 32	; pop stack 8 (push) times 4 bytes 8*4=32

    mov     esp, ebp	; takedown stack
    pop     ebp		; same as "exit"

	mov	eax,0		;  return normal value , no error
	ret			; return