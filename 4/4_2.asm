程序名renwu63
.386
DATA   SEGMENT USE16
DATA   ENDS
CODE   SEGMENT USE16
       ASSUME CS:CODE,SS:STACK
OLD_INT DW ?,?

NEW16H:CMP AH,00H
       JE  ATB
       CMP AH,10H
       JE  ATB
       JMP DWORD PTR OLD_INT
ATB:
       PUSHF
       CALL DWORD PTR OLD_INT
       CMP AL,41H            ;比较输入的ascii码
       JNZ NEXT1             ;
       MOV AL,42H
       JMP QUIT
NEXT1: CMP AL,42H
       JNZ NEXT2
       MOV AL,41H
       JMP QUIT
NEXT2: CMP AL,61H
       JNZ NEXT3
       MOV AL,62H
       JMP QUIT
NEXT3: CMP AL,62H
       JNZ QUIT
       MOV AL,61H

QUIT:  IRET
       
START: XOR AX,AX
       MOV DS,AX
       MOV AX,DS:[16H*4]        
       MOV OLD_INT,AX           ;保存偏移部分
       MOV AX,DS:[16H*4+2]
       MOV OLD_INT+2,AX         ;保存段值 
       CLI
       MOV WORD PTR DS:[16H*4],OFFSET NEW16H
       MOV DS:[16H*4+2],CS
       STI
       MOV DX,OFFSET START+15
       SHR DX,4
       ADD DX,10H
       MOV AL,0
       MOV AH,31H
       INT 21H
CODE   ENDS
STACK  SEGMENT USE16 STACK
       DB 200 DUP(0)
STACK  ENDS
       END START
