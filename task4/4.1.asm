stack_seg segment stack "stack"
    db 20 dup(?)
stack_seg ends

data_seg segment
    Arr dw 18 DUP(?)
    MinMax dw 2 DUP(0)
data_seg ends

code_seg segment "code"
    assume ss:stack_seg, ds:data_seg, cs:code_seg
    Start:
        ;set data segment
        mov ax,data_seg 
        mov ds,ax   
        ;find fibo nums
        mov Arr+0, 0; Arr[0] = 0
        mov Arr+2, 1; Arr[1] = 1
        mov CX, 16
        mov si,4
        fibo_loop:
            sub si, 2; i-1 indx
            mov ax, Arr[si]; ax = Arr[i-1]
            
            sub si, 2; i-2 indx
            add ax, Arr[si]; ax += Arr[i-2]

            add si, 4; i indx (i-2+2)

            mov Arr[si], ax; Arr[i] = ax

            add si, 2; i++
            loop fibo_loop
        
        ;find min odd elem in 2nd row 3*6 matrix 
        mov CX, 6; 6 iters
        mov si, 12; start from 6 index (12 because 1 cell = 2 byte)
        mov MinMax+0, 10000; initialize var for min elem
        find_min_loop:
            mov ax, Arr[si]
            call GetEvenBit; mov even bit to ax
            cmp AX, 0       ; if AX == 0 
            JE else_finded_min; num even, skip
                            ; else go to find min
            mov ax, Arr[si]
            cmp MinMax+0, ax ; if MinMax[0] <= Arr[i]
            JBE else_finded_min; jump to else_finded_min
            if_finded_min:
                mov ax, Arr[si] ; if MinMax[0] > Arr[i]
                mov MinMax+0, ax; MinMax[0] = Arr[i]
            else_finded_min:
            add si, 2; i++
            loop find_min_loop

        ;find max even elem in 4rd column 3*6 matrix 
        mov CX, 3; 3 iters
        mov si, 6; start from 3 index (6 because 1 cell = 2 byte)
        mov MinMax+2, 0; initialize var for max elem
        find_max_loop:
            mov ax, Arr[si]
            call GetEvenBit; mov even bit to ax
            cmp AX, 1       ; if AX == 1
            JE else_finded_max; num odd, skip
                            ; else go to find max
            mov ax, Arr[si]
            cmp MinMax+2, ax   ;if MinMax[1] >= Arr[i]
            JNB else_finded_max;jump to else_finded_max
            if_finded_max:
                mov ax, Arr[si] ; if MinMax[1] < Arr[i]
                mov MinMax+2, ax; MinMax[0] = Arr[i]
            else_finded_max:
            add si, 12; i+=6
            loop find_max_loop

        ; correct exit                
        mov ah,4ch         
        int 21h   

    GetEvenBit proc near; mov first bit (even bit) to AX
…       ror AX, 1; right cycle shift
        LAHF; move last 8 FLAGS bits to AH
        and AH, 00000001b; get first bit(CF), there is our shifted bit
        mov AL, AH
        mov AH, 0
    ret
    GetEvenBit endp

code_seg ends
end Start