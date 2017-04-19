.386
IDM_FILE_EXIT	equ 10001
IDM_Action_Average	equ	10101
IDM_Action_Sort	equ	10102
IDM_Action_List	equ	10103
IDM_HELP_ABOUT	equ 10201
2..rc
#define IDM_FILE_EXIT  10001
#define IDM_Action_Average  10101
#define IDM_Action_Sort  10102
#define IDM_Action_List  10103
#define IDM_HELP_ABOUT 10201

MyMenu  MENU
BEGIN
	POPUP "&File"
  	BEGIN
    		MENUITEM "E&xit",IDM_FILE_EXIT
	END
	POPUP "&Action"
  	BEGIN
    		MENUITEM "A&verage",IDM_Action_Average
    		MENUITEM "S&ort",IDM_Action_Sort
    		MENUITEM "L&ist",IDM_Action_List
	END
	
	
	POPUP "&Help"
	BEGIN
	    	MENUITEM "&About",IDM_HELP_ABOUT
	END
END
3..asm
.386
.model   flat,stdcall
option   casemap:none

WinMain  proto :DWORD,:DWORD,:DWORD,:DWORD
WndProc  proto :DWORD,:DWORD,:DWORD,:DWORD
Display  proto :DWORD

include      ex8.INC

include      windows.inc
include      user32.inc
include      kernel32.inc
include      gdi32.inc
include      shell32.inc

includelib   user32.lib
includelib   kernel32.lib
includelib   gdi32.lib
includelib   shell32.lib

student	     struct
	     myname   db  10 dup(0)
	     chinese  db  0
	     math     db  0
	     english  db  0
	     average  db  0
	     grade    db  0
student      ends

.data
ClassName    db       'TryWinClass',0
AppName      db       'Our First Window',0
MenuName     db       'MyMenu',0
DlgName	     db       'MyDialog',0
AboutMsg     db       '我是CS1307王镇宇',0
hInstance    dd       0
CommandLine  dd       0
buf	     student  <'Jin',97,98,99,98,'A'>
		 student  <'zhangsan',80,85,90,85,'A'>
		 student  <'lisi',95,90,95,93,'A'>
		 student  <'wangwu',80,75,85,80,'A'>
		 student  <'xiao',85,90,90,88,'A'>
	     
msg_name     db       'name',0
msg_chinese  db       'chinese',0
msg_math     db       'math',0
msg_english  db       'english',0
msg_average  db       'average',0
msg_grade    db       'grade',0
chinese	     db       2,'97','80','95','80', '85'
math	     db       2,'98','85','90','75', '90'
english	     db       2,'99','90','95','85', '90'
average	     db       2,'00','00','00','00', '00'

.code
Start:	     invoke GetModuleHandle,NULL
	     mov    hInstance,eax
	     invoke GetCommandLine
	     mov    CommandLine,eax
	     invoke WinMain,hInstance,NULL,CommandLine,SW_SHOWDEFAULT
	     invoke ExitProcess,eax
	     ;;
WinMain      proc   hInst:DWORD,hPrevInst:DWORD,CmdLine:DWORD,CmdShow:DWORD
	     LOCAL  wc:WNDCLASSEX
	     LOCAL  msg:MSG
	     LOCAL  hWnd:HWND
             invoke RtlZeroMemory,addr wc,sizeof wc
	     mov    wc.cbSize,SIZEOF WNDCLASSEX
	     mov    wc.style, CS_HREDRAW or CS_VREDRAW
	     mov    wc.lpfnWndProc, offset WndProc
	     mov    wc.cbClsExtra,NULL
	     mov    wc.cbWndExtra,NULL
	     push   hInst
	     pop    wc.hInstance
	     mov    wc.hbrBackground,COLOR_WINDOW+1
	     mov    wc.lpszMenuName, offset MenuName
	     mov    wc.lpszClassName,offset ClassName
	     invoke LoadIcon,NULL,IDI_APPLICATION
	     mov    wc.hIcon,eax
	     mov    wc.hIconSm,0
	     invoke LoadCursor,NULL,IDC_ARROW
	     mov    wc.hCursor,eax
	     invoke RegisterClassEx, addr wc
	     INVOKE CreateWindowEx,NULL,addr ClassName,addr AppName,\
                    WS_OVERLAPPEDWINDOW,CW_USEDEFAULT,\
                    CW_USEDEFAULT,CW_USEDEFAULT,CW_USEDEFAULT,NULL,NULL,\
                    hInst,NULL
	     mov    hWnd,eax
	     INVOKE ShowWindow,hWnd,SW_SHOWNORMAL
	     INVOKE UpdateWindow,hWnd
	     ;;
MsgLoop:     INVOKE GetMessage,addr msg,NULL,0,0
             cmp    EAX,0
             je     ExitLoop
             INVOKE TranslateMessage,addr msg
             INVOKE DispatchMessage,addr msg
	     jmp    MsgLoop 
ExitLoop:    mov    eax,msg.wParam
	     ret
WinMain      endp

WndProc      proc   hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
	     LOCAL  hdc:HDC
     .IF     uMsg == WM_DESTROY
	     invoke PostQuitMessage,NULL
     .ELSEIF uMsg == WM_KEYDOWN
	    .IF     wParam == VK_F1
			invoke MessageBox,hWnd,addr AboutMsg,addr AppName,0
             ;;your code
	    .ENDIF
     .ELSEIF uMsg == WM_COMMAND
	    .IF     wParam == IDM_FILE_EXIT
		    invoke SendMessage,hWnd,WM_CLOSE,0,0

		.ELSEIF wParam == IDM_Action_Average
		    invoke Display,hWnd
		.ELSEIF wParam == IDM_Action_Sort
		    invoke Display,hWnd
		.ELSEIF wParam == IDM_Action_List
		    invoke Display,hWnd

	    .ELSEIF wParam == IDM_HELP_ABOUT
		    invoke MessageBox,hWnd,addr AboutMsg,addr AppName,0
	    .ENDIF
     .ELSEIF uMsg == WM_PAINT
	     ;;redraw window again
     .ELSE
             invoke DefWindowProc,hWnd,uMsg,wParam,lParam
             ret
     .ENDIF
  	     xor    eax,eax
	     ret
WndProc      endp

Display      proc   hWnd:DWORD
             XX     equ  10
             YY     equ  10
	     XX_GAP equ  100
	     YY_GAP equ  30
             LOCAL  hdc:HDC
             invoke GetDC,hWnd
             mov    hdc,eax
             invoke TextOut,hdc,XX+0*XX_GAP,YY+0*YY_GAP,offset msg_name,4
             invoke TextOut,hdc,XX+1*XX_GAP,YY+0*YY_GAP,offset msg_chinese,7
             invoke TextOut,hdc,XX+2*XX_GAP,YY+0*YY_GAP,offset msg_math,4
             invoke TextOut,hdc,XX+3*XX_GAP,YY+0*YY_GAP,offset msg_english,7
             invoke TextOut,hdc,XX+4*XX_GAP,YY+0*YY_GAP,offset msg_average,7
             invoke TextOut,hdc,XX+5*XX_GAP,YY+0*YY_GAP,offset msg_grade,5
             ;;
             invoke TextOut,hdc,XX+0*XX_GAP,YY+1*YY_GAP,offset buf[0*15].myname,3
             invoke TextOut,hdc,XX+1*XX_GAP,YY+1*YY_GAP,offset chinese+1,chinese
             invoke TextOut,hdc,XX+2*XX_GAP,YY+1*YY_GAP,offset math+1,   math
             invoke TextOut,hdc,XX+3*XX_GAP,YY+1*YY_GAP,offset english+1,english
             invoke TextOut,hdc,XX+4*XX_GAP,YY+1*YY_GAP,offset average+1,average
             invoke TextOut,hdc,XX+5*XX_GAP,YY+1*YY_GAP,offset buf[0*15].grade,1
             ;;
             invoke TextOut,hdc,XX+0*XX_GAP,YY+1*YY_GAP,offset buf[1*15].myname,8
             invoke TextOut,hdc,XX+1*XX_GAP,YY+1*YY_GAP,offset chinese+2,chinese
             invoke TextOut,hdc,XX+2*XX_GAP,YY+1*YY_GAP,offset math+2,   math
             invoke TextOut,hdc,XX+3*XX_GAP,YY+1*YY_GAP,offset english+2,english
             invoke TextOut,hdc,XX+4*XX_GAP,YY+1*YY_GAP,offset average+2,average
             invoke TextOut,hdc,XX+5*XX_GAP,YY+1*YY_GAP,offset buf[1*15].grade,1
             ;;
             invoke TextOut,hdc,XX+0*XX_GAP,YY+1*YY_GAP,offset buf[2*15].myname,4
             invoke TextOut,hdc,XX+1*XX_GAP,YY+1*YY_GAP,offset chinese+3,chinese
             invoke TextOut,hdc,XX+2*XX_GAP,YY+1*YY_GAP,offset math+3,   math
             invoke TextOut,hdc,XX+3*XX_GAP,YY+1*YY_GAP,offset english+3,english
             invoke TextOut,hdc,XX+4*XX_GAP,YY+1*YY_GAP,offset average+3,average
             invoke TextOut,hdc,XX+5*XX_GAP,YY+1*YY_GAP,offset buf[2*15].grade,1
             ;;
             invoke TextOut,hdc,XX+0*XX_GAP,YY+1*YY_GAP,offset buf[3*15].myname,6
             invoke TextOut,hdc,XX+1*XX_GAP,YY+1*YY_GAP,offset chinese+4,chinese
             invoke TextOut,hdc,XX+2*XX_GAP,YY+1*YY_GAP,offset math+4,   math
             invoke TextOut,hdc,XX+3*XX_GAP,YY+1*YY_GAP,offset english+4,english
             invoke TextOut,hdc,XX+4*XX_GAP,YY+1*YY_GAP,offset average+4,average
             invoke TextOut,hdc,XX+5*XX_GAP,YY+1*YY_GAP,offset buf[3*15].grade,1
             ;;
             invoke TextOut,hdc,XX+0*XX_GAP,YY+1*YY_GAP,offset buf[4*15].myname,4
             invoke TextOut,hdc,XX+1*XX_GAP,YY+1*YY_GAP,offset chinese+5,chinese
             invoke TextOut,hdc,XX+2*XX_GAP,YY+1*YY_GAP,offset math+5,   math
             invoke TextOut,hdc,XX+3*XX_GAP,YY+1*YY_GAP,offset english+5,english
             invoke TextOut,hdc,XX+4*XX_GAP,YY+1*YY_GAP,offset average+5,average
             invoke TextOut,hdc,XX+5*XX_GAP,YY+1*YY_GAP,offset buf[4*15].grade,1
             ret
Display      endp

Average   proc  number:DWORD
        push    eax
    push    ebx
        push    ecx
        push    edx
        push    esi                    
        xor     ecx, ecx                              
avg_loop:
        cmp     ecx, number
        jge     avg_finish            
        xor     eax, eax
        xor     edx, edx
    imul    ebx, ecx, 15
        mov     al,  buf[ebx].chinese           
        mov     dl,  buf[ebx].math         
        lea     eax, [edx + eax * 2]  
        xor     edx, edx
        mov     dl,  buf[ebx].english         
        lea     esi, [edx + eax *2]    
        mov     eax, 92492493h        
        imul    esi
        add     edx, esi
        sar     edx, 2
        mov     eax, edx
        shr     eax, 1fh
        add     edx, eax
        mov     buf[ebx].average, dl
    .if dl > 90
        mov buf[ebx].stugrade, 'A'
    .elseif dl > 80
        mov buf[ebx].stugrade, 'B'
    .elseif dl > 70
        mov buf[ebx].stugrade, 'C'
    .elseif dl > 60
        mov buf[ebx].stugrade, 'D'
    .else
        mov buf[ebx].stugrade, 'E'
    .endif            
        inc     ecx                 
        jmp     avg_loop
avg_finish:
        pop     esi                
        pop     edx
        pop     ecx
    pop ebx
        pop     eax
        ret
Average   endp

             end  Start
