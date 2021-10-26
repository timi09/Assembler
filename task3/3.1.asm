stack_seg segment stack "stack"
    db 20 dup(?)
stack_seg ends

data_seg segment
    a db 15h;21
    b db 38h;56
    nod db 0;will be 7, sum of bits = 3 
data_seg ends

code_seg segment "code"
    assume ss:stack_seg, ds:data_seg, cs:code_seg
    Start:
        ;set data segment
        mov ax,data_seg 
        mov ds,ax   
        ;find NOD (GCD)
        mov dh, a
        mov dl, b
        cmp dh, dl
        ;CMP a, b
        JNAE if_b_max
        if_a_max:
            MOV AL, a
            MOV BL, b
            JMP end_if_b_max
        if_b_max:
            MOV AL, b
            MOV BL, a
        end_if_b_max:

        while_AH_not_0:
            MOV AH, 0
            DIV BL
            CMP AH, 0
            JE while_end

            MOV AL, BL
            MOV BL, AH
            JMP while_AH_not_0
        while_end: 
        MOV nod, BL

        ;get sum bits of nod(write in DX)
        MOV DX, 0
        MOV CX, 8; 8 loop iters, because byte has 8 bit
        loop_start:
            ror nod, 1; right cycle shift
            LAHF; move last 8 FLAGS bits to AH
            and AH, 00000001b; get first bit(CF), there is our shifted bit from nod
            add DL, AH
            mov AH, 0
            loop loop_start
        
        ; correct exit                
        mov ah,4ch         
        int 21h   
code_seg ends
end Start