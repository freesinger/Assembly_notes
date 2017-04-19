;*******************************;
;*         电子琴实验          *;
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
    int 21h              ;显示提示信息
    
    ; clear cx to store count info
    xor si,si
    mov cx,LEN
sing:    
    mov ah,0BH
    int 21h              ;从键盘接收字符,不回显
    cmp al,0ffh
    jz finish
    
    xor ax,ax
    
    mov al,byte ptr[rythm + si]
    dec al
    shl al,1
    mov bx,ax
    
    mov ax,4240H         ;计数初值 = 1000000 / 频率, 保存到AX
    mov dx,0FH
    div word ptr[tab + bx]
    mov bx,ax
    
    mov dx,io8253b          ;设置8253计时器0方式3, 先读写低字节, 再读写高字节
    mov al,00110110B
    out dx,al

    mov dx,io8253a         
    mov ax,bx
    out dx,al            ;写计数初值低字节
    
    mov al,ah
    out dx,al            ;写计数初值高字节
    
    mov dx,io8255b          ;设置8255 A口输出
    mov al,10000000B
    out dx,al
  
    mov dx,io8255a            
    mov al,03h
    out dx,al            ;置PA1PA0 = 11(开扬声器)
    call delay           ;延时
    mov al,0h
    out dx,al            ;置PA1PA0 = 00(关扬声器)
    
    add si,1
    cmp si,cx
    jl sing
finish:
    mov ax,4c00h
    int 21h
    
delay proc near          ;延时子程序
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
