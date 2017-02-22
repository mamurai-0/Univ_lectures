#include <stdlib.h>
#include <stdio.h>
#include <pthread.h>
#include "pthread_barrier.h" //OS X $B$K$O(Bpthread_barrier$B%7%j!<%:$r;H$&$?$a$N%i%$%V%i%j$,F~$C$F$$$J$$$?$aJL8D$K(Bpthread_barrier.h$B$rMQ0U$7$F$3$3$G(Binclude$B$9$k(B

#define N_ITEM 3 //$B0l$D$N%9%l%C%I$,=PNO$9$k%G!<%?$N8D?t$r;XDj$9$k(B
#define N_PRODUCER  5 //$B0l$D$N%9%l%C%I$,(Bbounded_buffer$B$KA^F~$9$k%G!<%?$N8D?t(B
#define N_CONSUMER  5 //$B0l$D$N%9%l%C%I$,(Bbounded_buffer$B$+$i<h$j=P$9%G!<%?$N8D?t(B
#define BSIZE  2 //bounded_buffer$B$N%P%C%U%!%5%$%:!#$3$l$,>.$5$$$[$I%9%l%C%I4V$N6%9g$,5/$3$j$d$9$/$J$k!#(B1$B$H$9$k$H%P%0$k$N$GCm0U(B($B$J$<$+!)!K(B

int bb_buf[BSIZE]; //bounded buffer$BK\BN(B
int count=0; //bounded buffer$B$K$"$k%G!<%?$N8D?t(B
int in, out; //bounded buffer$B$N<!$K%G!<%?$rA^F~$9$Y$-%$%s%G%/%9!"$*$h$S<h$j=P$9$Y$-%$%s%G%/%9(B
int waiting; //bounded buffer$B$KBP$9$k=hM}BT$A$r$7$F$$$k%G!<%?$N8D?t(B
pthread_mutex_t   bbmutex; // lock variable 
pthread_cond_t    bbcond; // condition variable
pthread_barrier_t pbarrier; // barrier variable (barrier variable$B$H$O!"F14|$r<h$k$?$a$NJQ?t!#$3$l$rMQ$$$F(Bpthread_barrier$B4X?t$r8F$V!#$3$l$i$O(Bproducer,consumer$B$G;H$o$l$F$$$k$,<+J,$G?7$7$/;H$&I,MW$O$J$$!#$h$C$F5$$K$7$J$/$FNI$$!#(B)

void bb_init() //$B3F!9$N%G!<%?$r=i4|2=$9$k4X?t(B
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

int bb_get() //bounded buffer$B$KBP$7$F%G!<%?$N<h$j=P$7$r9T$&4X?t(B
{
		pthread_mutex_lock(&bbmutex);
		int val;
		while(1){
				if(count==0)
				{
						pthread_cond_wait(&bbcond,&bbmutex);

				}else{
						val=bb_buf[out];//$BDI2C$7$?(B
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

void bb_put(int val) // bounded buffer$B$KBP$7$F%G!<%?$NA^F~$r9T$&4X?t(B
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

void *producer(void *arg)//main$B4X?t$N(Bpthread_create$B$+$i8F$S=P$9(B, start_routine$B$N%G!<%?A^F~HD!#:#2s$O%9%l%C%I$K$d$C$F$[$7$$=hM}$,(Bput$B$H(Bget$B$HFsDL$j$"$k$N$G$=$l$>$lJL$N(Bstart routine$B$rMQ0U$9$kI,MW$,$"$k(B
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

void *consumer(void *arg)//main$B4X?t$N(Bpthread_create$B$+$i8F$S=P$9!"(Bstart routine$B$N%G!<%?<h$j=P$7HD(B
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
		//void bb_init(); <= $B$3$l$O2?(B
		int i,cc,cc2;
		cc=0;
		cc2=0;
		pthread_t pth[N_PRODUCER+N_CONSUMER];
		void *retval;

		bb_init();
		pthread_barrier_init(&pbarrier, 0,  N_PRODUCER+N_CONSUMER);//barrier $BJQ?t$N$_$3$3$G=i4|2=$7$F$$$k(B

		for(i=0;i<N_PRODUCER;i++){ //$B%G!<%?$rA^F~$9$k%9%l%C%I$rN)$F$F$$$k(B
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
