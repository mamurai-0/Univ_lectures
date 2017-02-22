#include <stdlib.h>
#include <stdio.h>
#include <pthread.h>
#include "pthread_barrier.h"

#define N_ITEM 3
#define N_PRODUCER  3
#define N_CONSUMER  3
#define BSIZE  2

int bb_buf[BSIZE];
int count;
int in, out;
int waiting;
pthread_mutex_t   bbmutex;
pthread_cond_t    bbcond;
pthread_barrier_t pbarrier;

void bb_init()
{
		pthread_mutex_init(&bbmutex, NULL);
   		pthread_cond_init(&bbcond, NULL);
   		in=0;
   		out=0;
		waiting=0;
}

int bb_get()
{
		int val;
		pthread_mutex_lock(&bbmutex);
   		while(1){
   				if(count>0){
   						val = bb_buf[out];
   						--count;
   						out = (out+1)%BSIZE;
   						if(waiting){
   								pthread_cond_signal(&bbcond);
   						}
   						break;
   				}else{
   						waiting++;
    					pthread_cond_wait(&bbcond, &bbmutex);
   						--waiting;
   				}
   		}
   		pthread_mutex_unlock(&bbmutex);
   		return val;
}
   
void bb_put(int val)
{
		pthread_mutex_lock(&bbmutex);
   		while(1){
   				if(count < BSIZE){
   						bb_buf[in] = val;
   						count++;
   						in = (in+1)%BSIZE;
   						if(waiting){
   								pthread_cond_signal(&bbcond);
   						}
   						break;
   				}else{
   						waiting++;
   						pthread_cond_wait(&bbcond, &bbmutex);
   						--waiting;
   				}
   		}
   		pthread_mutex_unlock(&bbmutex);
   		return;
}
 
void *producer(void *arg)
{
   		int ret = 0;
   		int i;
		pthread_barrier_wait(&pbarrier);
		for(i=0;i<(N_CONSUMER*N_ITEM)/N_PRODUCER;i++){
				bb_put(i);
   		}
   		pthread_exit(&ret);
   		return 0;
}
   
void *consumer(void *arg){
   		int ret = 0;
		int i;
   		int val;
   		pthread_barrier_wait(&pbarrier);
   		for(i=0;i<N_ITEM;i++){
   				val = bb_get();
   				printf("bb_get()=%d\n", val);
   		}
   		pthread_exit(&ret);
   		return 0;
}

int main()
{
		int i,cc;
   		pthread_t pth[N_PRODUCER+N_CONSUMER];
   		void *retval;
   		bb_init();
   		pthread_barrier_init(&pbarrier, 0,  N_PRODUCER+N_CONSUMER);
   		for(i=0;i<N_PRODUCER;i++){
   				cc = pthread_create(&pth[i], NULL, producer, 0);
   				if(cc != 0){
   						perror("producer");
   						return -1;
   				}
		}

   		for(i=0;i<N_CONSUMER;i++){
   				cc = pthread_create(&pth[i+N_PRODUCER], NULL, consumer, 0);
   				if(cc != 0){
   						perror("consumer");
   						return -1;
   				}
   		}
   		for(i=0;i<(N_PRODUCER+N_CONSUMER);i++){
   				pthread_join(pth[i], &retval);
   				pthread_detach(pth[i]);
   		}
   		return 0;
}
