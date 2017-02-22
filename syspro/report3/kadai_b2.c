#include <stdlib.h>
#include <stdio.h>
#include <pthread.h>
#include "pthread_barrier.h" //OS X にはpthread_barrierシリーズを使うためのライブラリが入っていないため別個にpthread_barrier.hを用意してここでincludeする

#define N_ITEM 3 //一つのスレッドが出力するデータの個数を指定する
#define N_PRODUCER  5 //一つのスレッドがbounded_bufferに挿入するデータの個数
#define N_CONSUMER  5 //一つのスレッドがbounded_bufferから取り出すデータの個数
#define BSIZE  2 //bounded_bufferのバッファサイズ。これが小さいほどスレッド間の競合が起こりやすくなる。1とするとバグるので注意(なぜか？）

int bb_buf[BSIZE]; //bounded buffer本体
int count=0; //bounded bufferにあるデータの個数
int in, out; //bounded bufferの次にデータを挿入すべきインデクス、および取り出すべきインデクス
int waiting; //bounded bufferに対する処理待ちをしているデータの個数
pthread_mutex_t   bbmutex; // lock variable 
pthread_cond_t    bbcond; // condition variable
pthread_barrier_t pbarrier; // barrier variable (barrier variableとは、同期を取るための変数。これを用いてpthread_barrier関数を呼ぶ。これらはproducer,consumerで使われているが自分で新しく使う必要はない。よって気にしなくて良い。)

void bb_init() //各々のデータを初期化する関数
{
		int i;
		pthread_mutex_init(&bbmutex, NULL);
		pthread_cond_init(&bbcond, NULL);
		in=0;
		out=0;
		waiting=0;
		for(i=0;i<=BSIZE-1;i++){
				bb_buf[i]=0;
		}
}

int bb_get() //bounded bufferに対してデータの取り出しを行う関数
{
		pthread_mutex_lock(&bbmutex);
		int val;
		while(1){
				if(count==0)
				{
						pthread_cond_wait(&bbcond,&bbmutex);

				}else{
						val=bb_buf[out];//追加した
						out=(out+1)%BSIZE;
						count--;//count=(count-1)%BSIZE;
						pthread_cond_signal(&bbcond);

						break;
				}
//
//				pthread_mutex_unlock(&bbmutex);
//		}
//		return bb_buf[out-1];
        }
		pthread_mutex_unlock(&bbmutex);
		return val;
}

void bb_put(int val) // bounded bufferに対してデータの挿入を行う関数
{
		pthread_mutex_lock(&bbmutex);
		while(1){
				if(count>=BSIZE)
				{
						pthread_cond_wait(&bbcond,&bbmutex);

				}else{
						bb_buf[in]=val;
						count++;//count=(count+1)%BSIZE;
						in=(in+1)%BSIZE;
						pthread_cond_signal(&bbcond);
						break;
				}
		}
		pthread_mutex_unlock(&bbmutex);
}

void *producer(void *arg)//main関数のpthread_createから呼び出す, start_routineのデータ挿入板。今回はスレッドにやってほしい処理がputとgetと二通りあるのでそれぞれ別のstart routineを用意する必要がある
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

void *consumer(void *arg)//main関数のpthread_createから呼び出す、start routineのデータ取り出し板
{
		int ret = 0;
		int i;
		int val;
		pthread_barrier_wait(&pbarrier);
		for(i=0;i<N_ITEM;i++){
				val = bb_get();
				printf("bb_get=()=%d\n", val);
		}
		pthread_exit(&ret);
		return 0;
}

int main()
{
		//void bb_init(); <= これは何
		int i,cc,cc2;
		cc=0;
		cc2=0;
		pthread_t pth[N_PRODUCER+N_CONSUMER];
		void *retval;

		bb_init();
		pthread_barrier_init(&pbarrier, 0,  N_PRODUCER+N_CONSUMER);//barrier 変数のみここで初期化している

		for(i=0;i<N_PRODUCER;i++){ //データを挿入するスレッドを立てている
				cc = pthread_create(&pth[i], NULL, producer, 0);
				if(cc != 0){
						perror("producer error");
						return -1;
				}
		}

		for(i=0;i<N_CONSUMER;i++){
				cc2 = pthread_create(&pth[i], NULL, consumer, 0);
				if(cc2 !=0){
						perror("comsumer error");
						return -1;
				}
		}

		for(i=0;i<(N_PRODUCER+N_CONSUMER);i++){
				pthread_join(pth[i], &retval);
				pthread_detach(pth[i]);
		}
		return 0;
}
