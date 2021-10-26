;stack segment
s_s segment stack "stack" 
 db 20 dup(?)   
s_s ends

;first data segment
d_s1 segment      
 aa db 00000111b  
d_s1 ends 

c_s2 segment "code"
assume ss:s_s,cs:c_s2
jmp m2
c_s2_strt:
assume ss:s_s,ds:d_s1,cs:c_s2
;change data segment
 mov ax,d_s1
 mov ds,ax 

 ;add 3rd bit in CF
 ror aa, 3
 
 LAHF;move last 8 FLAGS bit to ah
 mov bl, ah
 and bl, 00000001b;get first bit(CF)

 jmp FAR PTR ext
m2:
c_s2 ends  


c_s1 segment "code"
assume ss:s_s,cs:c_s1
jmp m1
c_s1_strt:
assume ss:s_s,ds:d_s3,cs:c_s1
 ;change data segment
 mov ax,d_s3
 mov ds,ax 

 ;add 5rd bit in CF
 ror bb, 5
 
 LAHF;move last 8 FLAGS bit to ah
 mov bh, ah
 and bh, 00000001b;get first bit(CF)

 jmp FAR PTR c_s2_strt

m1:
c_s1 ends  

;second data segment
d_s2 segment 
 code_segment1 dd c_s1_strt 
d_s2 ends

;third data segment
d_s3 segment 
 bb db 01001010b  
d_s3 ends


c_s3 segment "code"; third code segment
 assume ss:s_s,ds:d_s1, cs:c_s3
begin:
 ;set data segment
 mov ax,d_s1 
 mov ds,ax   
 
 ;*2                   
 sal aa, 1

 ;change data segment
 assume ds:d_s3
 mov ax,d_s3
 mov ds,ax 

 ;/4
 sar bb, 2

 ;change data segment
 assume ds:d_s2
 mov ax,d_s2
 mov ds,ax 

 jmp [code_segment1]

ext:; correct exit                
 mov ah,4ch         
 int 21h       

c_s3 ends             
end begin 


