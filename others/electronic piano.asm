;*******************************;
;*         ������ʵ��          *;
;*******************************;

data segment
io8255a        equ 288h
io8255b        equ 28bh
io8253a     equ 280h
io8253b        equ 283h
rythm db 1,2,3,1,1,2,3,1,3,4,5,5,3,4,5,5,5,6,5,4,3,3,1,1,5,6,5,4,3,3,1,1,2,2,13,13,1,1,0,0,2,2,13,13,1,1,0,0
LEN EQU $-rythm
tab dw 524,588,660,698,784,880,988,1048,262,294,330,347,392,440,494,524
msg db 'Press any key to stop',0dh,0ah,'$'
data ends

code segment
assume cs:code,ds:data
start:
    mov ax,data
    mov ds,ax

    mov dx,offset msg
    mov ah,9
    int 21h              ;��ʾ��ʾ��Ϣ
    
    ; clear cx to store count info
    xor si,si
    mov cx,LEN
sing:    
    mov ah,0BH
    int 21h              ;�Ӽ��̽����ַ�,������
    cmp al,0ffh
    jz finish
    
    xor ax,ax
    
    mov al,byte ptr[rythm + si]
    dec al
    shl al,1
    mov bx,ax
    
    mov ax,4240H         ;������ֵ = 1000000 / Ƶ��, ���浽AX
    mov dx,0FH
    div word ptr[tab + bx]
    mov bx,ax
    
    mov dx,io8253b          ;����8253��ʱ��0��ʽ3, �ȶ�д���ֽ�, �ٶ�д���ֽ�
    mov al,00110110B
    out dx,al

    mov dx,io8253a         
    mov ax,bx
    out dx,al            ;д������ֵ���ֽ�
    
    mov al,ah
    out dx,al            ;д������ֵ���ֽ�
    
    mov dx,io8255b          ;����8255 A�����
    mov al,10000000B
    out dx,al
  
    mov dx,io8255a            
    mov al,03h
    out dx,al            ;��PA1PA0 = 11(��������)
    call delay           ;��ʱ
    mov al,0h
    out dx,al            ;��PA1PA0 = 00(��������)
    
    add si,1
    cmp si,cx
    jl sing
finish:
    mov ax,4c00h
    int 21h
    
delay proc near          ;��ʱ�ӳ���
    push cx
    push ax
    mov ax,100
x1: mov cx,0ffffh
x2: dec cx
    jnz x2
    dec ax
    jnz x1
    pop ax
    pop cx
    ret
delay endp
code ends
end start
