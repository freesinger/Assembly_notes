优化前的代码（优化部分的代码见任务二实验记录）：
.386
STACK   SEGMENT     USE16   STACK
        DB 200  DUP(0)
STACK   ENDS

DATA    SEGMENT     USE16
        COUNT   DD  100000000
        BUF     DB  'zhangsan',0,0
                DB  100,85,80,?
        MSG     DB  'Input the  name : $'
        CONTINU DB  'Enter q to exit:$'
        INPUT   DB  10
                DB  ?
                DB  10 DUP(0)
DATA    ENDS

CODE    SEGMENT     USE16
        ASSUME  CS:CODE, DS:DATA, SS:STACK
START:  MOV     AX, DATA
        MOV     DS, AX
        JMP     BEGIN
        
BEGIN:  LEA     DX, OFFSET MSG      ;输出提示信息
        MOV     AH, 9H
        INT     21H
        LEA     DX, OFFSET INPUT    ; 读入学生姓名
        MOV     AH, 0AH
        INT     21H
        MOV     DL, 0AH             ; 换行符
        MOV     AH, 2H
        INT     21H
        
        MOV  AX, 0	;表示开始计时
        CALL TIMER

NEXT:   LEA     BP, OFFSET INPUT     ; 将 INPUT 基址存放至 BP
        ADD     BP,2
        LEA     BX, OFFSET BUF     ; 将 BUF 基址存放至 BX
        MOV     SI,-1
        
COMP:   INC     SI
        MOV     DL, [BX + SI]
        MOV     DH, BYTE PTR DS:[BP + SI]
        
        CMP     DL,0
        JZ      CAL
        CMP     DL,DH
        JZ      COMP
        
CAL:    ADD     BX, 10     ; 根据目标学生下标值, 找到分数缓冲区首地址 BX = 10
        MOV     AX, 0
        MOV     DX, 2
        MOV     AL, [BX]    ; 计算平均成绩
        IMUL    DX
        MOV     DL, [BX +1]
        ADD     DX,AX       ;A*2+B 
        MOV     AL, [BX +2]
        MOV     CX,2
        IDIV    CL
        ADD     AX, DX      ;AL=A*2+B+C/2
        IMUL    CL
        MOV     DL, 7
        IDIV    DL          ; AL = 2 * AL / 7
        MOV     [BX + 3], AL; AVG = AL ( AL / 3.5)
        
        DEC     COUNT
        JNZ     NEXT
        
        MOV  AX, 1
	    CALL TIMER	;终止计时并显示计时结果(ms)

LOOPA:  MOV     DL, 0AH             ;换行符
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
  
TIMER	PROC
	PUSH  DX
	PUSH  CX
	PUSH  BX
	MOV   BX, AX
	MOV   AH, 2CH
	INT   21H	     ;CH=hour(0-23),CL=minute(0-59),DH=second(0-59),DL=centisecond(0-100)
	MOV   AL, DH
	MOV   AH, 0
	IMUL  AX,AX,1000
	MOV   DH, 0
	IMUL  DX,DX,10
	ADD   AX, DX
	CMP   BX, 0
	JNZ   _T1
	MOV   CS:_TS, AX
_T0:	POP   BX
	POP   CX
	POP   DX
	RET
_T1:	SUB   AX, CS:_TS
	JNC   _T2
	ADD   AX, 60000
_T2:	MOV   CX, 0
	MOV   BX, 10
_T3:	MOV   DX, 0
	DIV   BX
	PUSH  DX
	INC   CX
	CMP   AX, 0
	JNZ   _T3
	MOV   BX, 0
_T4:	POP   AX
	ADD   AL, '0'
	MOV   CS:_TMSG[BX], AL
	INC   BX
	LOOP  _T4
	PUSH  DS
	MOV   CS:_TMSG[BX+0], 0AH
	MOV   CS:_TMSG[BX+1], 0DH
	MOV   CS:_TMSG[BX+2], '$'
	LEA   DX, _TS+2
	PUSH  CS
	POP   DS
	MOV   AH, 9
	INT   21H
	POP   DS
	JMP   _T0
_TS	DW    ?
 	DB    'Time elapsed in ms is '
_TMSG	DB    12 DUP(0)
TIMER   ENDP
        
OVER:   MOV     AH, 4CH
        INT     21H
CODE    ENDS
        END     START
