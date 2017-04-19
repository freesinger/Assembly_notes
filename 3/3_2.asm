
.386	
.model flat, c
.code
public dif
dif		proc	par1:dword,par2:dword
			    mov		ecx, 1000
				mov		edi, par1;
		LOAPI:
				mov		esi, par2
				mov		edx, 12
		LOAPJ:
				  mov		al, byte ptr[esi]
				  mov		bl, byte ptr[edi]
				  cmp		al, bl
				  jnz		NEXT
				  cmp		al, 0
				  jz		FIGURE
				  dec		edx
				  inc		edi
				  inc		esi
				  jmp		LOAPJ
		NEXT:
				dec		ecx
				jz		REINPUT
				add		edx, 8
				add		edi, edx
				jmp		LOAPI
		FIGURE:
				add		edi, edx
				mov		al, byte ptr[edi]
				mov		ah, 0
				add		ax, ax
				add		ax, ax
				mov		dl, byte ptr[edi + 2]
				mov		dh, 0
				add		ax, dx
				add		ax, dx
				mov		dl, byte ptr[edi + 4]
				mov		dh, 0
				add		ax, dx
				mov		bl, 7
				div		bl
				mov		ah, 0
				mov		word ptr[edi + 6], ax
		REINPUT:
				ret
				dif endp 
end

C语言主程序
#include<stdlib.h>
#include<stdio.h>
#include<string.h>

struct Stu{
	char name[12];		//储存姓名
	short score[4];		//储存成绩
};
extern  void dif(struct stuinfo  *, char *);
int main() {
	struct Stu info[3];
	char	name[12];		//输入的姓名
	int		i, j;				//计数器
	char	op;
//初始化三个学生信息用于测试
	strcpy(info[0].name,"zhangsan_a");
	info[0].score[0] = 86;
	info[0].score[1] = 82;
	info[0].score[2] = 88;
	info[0].score[3] = 0;
	
	strcpy(info[1].name, "zhangsan_b");
	info[1].score[0] = 48; 
	info[1].score[1] = 79; 
	info[1].score[2] = 46; 
	info[1].score[3] = 0;
	
	strcpy(info[2].name, "zhangsan_c");
	info[2].score[0] = 96;
	info[2].score[1] = 92;
	info[2].score[2] = 98; 
	info[2].score[3] = 0;
	do{
		printf("Inlut the name of the student:");
		gets_s(name, 12);
		dif(info, name);
		for (i = 0; i < 3; i++){
			if (!strcmp(info[i].name, name)){
				printf("%s\t", info[i].name);
				for (j = 0; j < 4; j++){
					printf("%d\t", info[i].score[j]);
				}
				printf("\n");
			}
		}
		printf("Input Y to exit,N continue...");
		op = getchar(); getchar();
	} while (op == 'Y' || op == 'y');
	for (i = 0; i < 3; i++) {
		printf("%s\t", info[i].name);
		for (j = 0; j < 4; j++){
			printf("%d\t", info[i].score[j]);
		}
		printf("\n");
	}
	getchar();
	return 0;
}
