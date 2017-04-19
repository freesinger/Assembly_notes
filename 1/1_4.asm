.386	
STACK   SEGMENT     USE16   STACK
        DB 200  DUP(0)
STACK   ENDS
DATA    SEGMENT     USE16
        N       EQU 3
        BUF     DB  'zhangsan',0,0
                DB  100,85,80,?
                DB  'lisi',6 DUP(0)
                DB  80,100,70,?
                DB  'wangwu',4 DUP(0)
                DB  85,85,100,?
        MSG     DB  'Input the  name : $'
        CONTINU DB  'Enter any keys to continue(if enter q,exit!):$'
        FAIL    DB  'Not Exist!$'
        INPUT   DB  10
                DB  ?
                DB  10 DUP(0)
DATA    ENDS
CODE    SEGMENT     USE16
        ASSUME  CS:CODE, DS:DATA, SS:STACK
START:  MOV     AX, DATA
        MOV     DS, AX
        JMP     BEGIN
FAILED: LEA     DX, OFFSET FAIL     ; 查找失败
        MOV     AH, 9H
        INT     21H
LOOPA:   MOV     DL, 0AH             ;换行符
        MOV     AH, 2H
        INT     21H
        LEA     DX, OFFSET CONTINU  ;继续
        MOV     AH, 9H
        INT     21H
        MOV     DL, 0AH             ;换行符
        MOV     AH, 2H
        INT     21H
        MOV     DL, 0DH             
        MOV     AH, 2H
        INT     21H
        MOV     AH, 8H
        INT     21H
        CMP     AL, 71H
        JE      OVER                ;输入 'q', 退出程序
BEGIN:  MOV     CX, N               ; 学生个数
        LEA     DX, OFFSET MSG      ;输出提示信息
        MOV     AH, 9H
        INT     21H
        MOV     DL, 0AH             ; 换行符
        MOV     AH, 2H
        INT     21H
        LEA     DX, OFFSET INPUT    ; 读入学生姓名
        MOV     AH, 0AH
        INT     21H
        MOV     DL, 0AH             ; 换行符
        MOV     AH, 2H
        INT     21H
        LEA     BP, OFFSET INPUT     ; 将 INPUT 基址存放至 BP
        ADD     BP,2  
	    CMP     DS:BYTE PTR [BP-1],0H   ;空字符串
        JE      LOOPA
        INC     CX
COMPA:  DEC     CX
        JE      FAILED      ; 查找失败, 重新输入
        MOV     BX, N       ; 计算目标学生下标值, 存放至 BX
        SUB     BX, CX
        IMUL    BX, 14      ; 根据目标学生下标值, 找到分数缓冲区首地址
        MOV     AX, 10      ; 临时计数器
        MOV     SI, 0
COMPB:  MOV     DL, [BX + SI]
        MOV     DH, BYTE PTR DS:[BP + SI]
        CMP     DL, 0       ; 如果缓冲区姓名已结束,说明查找成功
        JE      CAL         ; 跳转至平均成绩计算处
        CMP     DH, DL      ; 比较 当前缓冲区姓名 与 输入姓名 字符
        JNE     COMPA       ; 当前字符相同,继续循环以比较下一字符
        INC     SI
        DEC     AX
        JNE     COMPB
CAL:    MOV     BX, N       ; 计算目标学生下标值, 存放至 BX
        SUB     BX, CX
        IMUL    BX, 14      
        ADD     BX, 10     ; 根据目标学生下标值, 找到分数缓冲区首地址 BX = m * 14 + 10
        MOV     AX, 0
        MOV     DX, 0
        MOV     AL, [BX]    ; 计算平均成绩
        ADD     AX, AX      
        MOV     DL, [BX +1]
        ADD     AX, DX      
        MOV     DL, [BX +2]
        SAR     DL, 1
	    ADD     AX, DX       ;AL=A*2+B+C/2
	    SAL     AX, 1
        MOV     DL, 7
        IDIV    DL          ; AL = 2 * AL / 7
        MOV     [BX + 3], AL; AVG = AL ( AL / 3.5)
        CMP     AL, 90      
        JGE     LEVELA
        CMP     AL, 80
        JGE     LEVELB
        CMP     AL, 70
        JGE     LEVELC
        CMP     AL, 60
        JGE     LEVELD
        JMP     LEVELF
LEVELA:MOV     DL, 41H    ;输出成绩等级
        MOV     AH, 2H
        INT     21H
        JMP     LOOPA
LEVELB:MOV     DL, 42H
        MOV     AH, 2H
        INT     21H
        JMP     LOOPA
LEVELC:MOV     DL, 43H
        MOV     AH, 2H
        INT     21H
        JMP     LOOPA
LEVELD:MOV     DL, 44H
        MOV     AH, 2H
        INT     21H
        JMP     LOOPA
LEVELF:MOV     DL, 46H
        MOV     AH, 2H
        INT     21H
        JMP     LOOPA
OVER:   MOV     AH, 4CH
        INT     21H
CODE    ENDS
        END     START
