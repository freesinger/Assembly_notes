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
