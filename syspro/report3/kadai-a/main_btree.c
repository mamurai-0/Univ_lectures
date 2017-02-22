#define _REENTRANT

#include "btree.h"
#include <pthread.h>

struct tnode *tree;

void *func(void *arg)
{
		int *p = (int *)arg;

		pthread_mutex_lock(&m);
        tree = btree_insert(*p, tree);
        pthread_mutex_unlock(&m);
		pthread_exit(NULL);
}

int main()
{
		pthread_t thread[100];
		int i,ite;
		int a[100];
		puts("start");
		for(i=0;i<100;i++){
				a[i]=i;
		}
		scanf("%d", &ite);

        tree = btree_create();
		for(i=0;i<ite;i++){
				if(pthread_create(&thread[i], NULL, func, &a[i]) != 0){
						printf("error: pthread_create\n");
				        return 1;
		        }
		}
		for(i=0;i<ite;i++){
				if(pthread_join(thread[i], NULL) != 0){
						printf("error: pthread_join\n");
						return 1;
				}
		}

		btree_dump(tree);
		btree_destroy(tree);
		return 0;
}
