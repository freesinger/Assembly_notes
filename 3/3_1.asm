;主程序
;功能：定义数据段，打印功能菜单 

PUBLIC	BUF
PUBLIC	N
EXTRN	SORT:NEAR
EXTRN	PRINT:NEAR
.386	
STACK   SEGMENT     USE16   STACK
        DB 200  DUP(0)
STACK   ENDS

DATA    SEGMENT     USE16		PUBLIC
        
        BUF     DB  10	DUP(0)
        		DB	?,?,?,?
        		DB  10	DUP(0)
        		DB	?,?,?,?
        		DB  10	DUP(0)
        		DB	?,?,?,?
        		DB  10	DUP(0)
        		DB	?,?,?,?
                
        N       DW  0   
		S		DW	0    
        TIP1    DB  'Please make the choice: $'
        TIP2    DB  '1 input name$'
        TIP3    DB  '2 calculate score$'
        TIP4    DB  '3 sorting order$'
        TIP5    DB  '4 print$'
        TIP6    DB  '5 exit$'
        
        INPUT_N   DB  12
                  DB  ?
                  DB  10 DUP(0)
        INPUT_S   DB  6
                  DB  ?
                  DB  4 DUP(0)
                
DATA    ENDS

CODE    SEGMENT     USE16	PUBLIC
        ASSUME  CS:CODE, DS:DATA, SS:STACK
START:  MOV     AX, DATA
        MOV     DS, AX
        
        NINE	MACRO A         ;宏定义9号调用 
                LEA     DX,A
                MOV     AH,9
                INT     21H
                ENDM
        
MENU:   NINE	TIP1     ;输出菜单 
        MOV     DL,0AH
        MOV     AH,2
        INT     21H
        MOV     DL,0DH
        MOV     AH,2
        INT     21H
        
        NINE	TIP2
        MOV     DL,0AH
        MOV     AH,2
        INT     21H
        MOV     DL,0DH
        MOV     AH,2
        INT     21H
        
        NINE	TIP3
        MOV     DL,0AH
        MOV     AH,2
        INT     21H
        MOV     DL,0DH
        MOV     AH,2
        INT     21H
        
        NINE	TIP4
        MOV     DL,0AH
        MOV     AH,2
        INT     21H
        MOV     DL,0DH
        MOV     AH,2
        INT     21H
        
        NINE	TIP5
        MOV     DL,0AH
        MOV     AH,2
        INT     21H
        MOV     DL,0DH
        MOV     AH,2
        INT     21H
        
        NINE	TIP6
        MOV     DL,0AH
        MOV     AH,2
        INT     21H
        MOV     DL,0DH
        MOV     AH,2
        INT     21H
        
        MOV     AH,1
        INT     21H
        
        ;MOV     DL,0AH
        ;MOV     AH,2
        ;INT     21H
        ;MOV     DL,0DH
        ;MOV     AH,2
        ;INT     21H
        
        
        CMP     AL,31H
        JZ      L1
        CMP     AL,32H
        JZ      L2
        CMP     AL,33H
        JZ      L3
        CMP     AL,34H
        JZ      L4
        CMP     AL,35H
        JZ      OVER
        JMP     MENU
        
OVER:
		MOV     AH, 4CH
        INT     21H
        
L1:     CALL    LOPA1
		JMP		MENU 
L2:     CALL    LOPA2
		JMP		MENU
L3:     CALL    SORT
		JMP		MENU
L4:     CALL    PRINT
		JMP		MENU

;子程序1
;功能：输入4个学生的姓名和成绩         
;寄存器分配：   CL:输入姓名字符串长度 
;				CH:计数：每个学生3次输入成绩 
;				SI:循环录入姓名和成绩时SI每+1实现BUF段14个字节的跳跃 
;				BX:计数：+1在INPUT_N和INPUT_S和BUF段中实现后移 
;				AX:存放姓名的字符和成绩的字符 
;				DX:在将输入成绩字符转换为实际成绩时存放成绩 
       
LOPA1   PROC    NEAR

        TEN	MACRO B         ;宏定义10号调用 
            LEA     DX,B
            MOV     AH,10
            INT     21H
            ENDM
        MOV     SI,0

LOOP1A: 
        MOV     BX,0
		TEN	    INPUT_N
		
		MOV     DL,0AH
        MOV     AH,2
        INT     21H
        MOV     DL,0DH
        MOV     AH,2
        INT     21H
        
        MOV     CL,INPUT_N[1]
NEXT_N:
        PUSH	AX
        MOV		AX,N
        IMUL	AX,14
        MOV		SI,AX
        POP		AX
        MOV     AL,INPUT_N[2+BX] 
		MOV		[BX+SI],AL     
        INC     BX
        DEC     CL			;把每个字符放入BUF段 
        JNZ     NEXT_N
        
        MOV     CH,0        ;三门课的成绩 
SCORE:        
        MOV     BX,0
        TEN     INPUT_S
        
        MOV     DL,0AH
        MOV     AH,2
        INT     21H
        MOV     DL,0DH
        MOV     AH,2
        INT     21H
        
        MOV     DL,100
        MOV		DH,0
        MOV     CL,INPUT_S[1]		;输入成绩长度，输入3位数进行转换 
        
NEXT_S:                             ;把输入的字符串转为10进制成绩 
        
        PUSH	AX
        MOV		AX,N
        IMUL	AX,14
        MOV		SI,AX
        POP		AX
        MOV     AL,INPUT_S[2+BX]
        SUB		AL,30
        IMUL    DL					;(AL)*DL->AX
        
        ADD		DH,AL
        
        INC     BX
        PUSH    AX
        PUSH	BX
        XOR		AX, AX
        MOV     AL,DL				;(DL)->AL
        MOV     BL,10				;
        IDIV    BL					;(AX)/10->AL
        MOV     DL,AL				;(AL)->DL
        POP		BX
        POP     AX
        
        DEC     CL
        JNZ     NEXT_S			;成绩的3个字符进行转换 
        
        ADD		BL,CH
        MOV     [BX+SI+7],DH		;把成绩放入BUF[10]
        
        INC     CH
        CMP		CH,3
        JNZ     SCORE			;循环3次输入成绩 
        
        INC     N
        CMP     N,4           ;循环输入4个人的信息 
        JNZ     LOOP1A
        
        RET
        
LOPA1   ENDP


;子程序2
;功能：计算4个学生的平均成绩 
;寄存器分配：	BX:+1实现寻找成绩所在的字节 
;				SI:每+1实现一个学生到另一个学生的跳跃 
;        		AX:存放3门课相加后的成绩 
;				CX:		CL:3门课成绩		CX:4个学生 

LOPA2   PROC    NEAR
        MOV		SI,0
        MOV		CH,4
NEXT2:		
		MOV		AX,0
		MOV		BX,0
        MOV		CL,3
        
		PUSH	AX
		MOV		AX,S
		IMUL	AX,14
		MOV		SI,AX
		POP		AX
NEXT1:		
		MOV		DL,BUF[BX+SI+10]
		ADD		AL,DL
		INC		BX
		
		DEC		CL
		JNZ		NEXT1			;三门课成绩相加 
		
		MOV		CL,3
		IDIV	CL
		MOV		BUF[SI+13],AL
		
		INC		S
		DEC		CH
		JNZ		NEXT2
        RET
        
LOPA2   ENDP
      
CODE    ENDS
        END     START        
