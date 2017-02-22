#define _REENTRANT
#define N 10

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>

typedef struct bnode *Bbuf;
struct bnode{
		int bb_buf[N];
		int start;
		int end;
};

int bb_get(Bbuf b, int *mem)
{
		int i;
		if(b->bb_buf[0]==0)
		{
				//他のスレッドがbb_putするまで待つ
		}else{
				for(i=0;i<=b->end;i++)
				{
						mem[i]=b->bb_buf[i];
				}
		}
		return *mem;
}

void bb_put(Bbuf b, int arg)
{		
		if(b->end>=N)
		{
				printf("buffer is full\n");
		}else{
				b->bb_buf[b->end]=arg;
		}
}

int main()
{
		int arg,i,j;
		int mem[N];
		char cmd[10];
		Bbuf b;
		b=malloc(sizeof(struct bnode));

		for(j=0;j<=N;j++){
				mem[j]=0;
				b->bb_buf[j]=0;
		}

		b->start=b->bb_buf[0];
		b->end=b->bb_buf[N-1];

		printf("put or get?");

		while((scanf("%s", cmd)!=EOF)){
				if(strcmp(cmd,"put")==0){
						scanf("%d", &arg);
						bb_put(b, arg);
				}else if(strcmp(cmd,"get")==0){
						bb_get(b, mem);
					    for(i=0;i<=N;i++){
								printf("%d\n", mem[i]);
						}
				}else{
						printf("UNKOWN COMMAND\n");
				}
				cmd[0]='\0';
		}
		return 0;
}
