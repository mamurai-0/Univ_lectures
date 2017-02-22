#include <stdio.h>
#include <sys/time.h>
#include <sys/types.h>
#include <sys/syscall.h>
#include <unistd.h>

int main(int argc, char *argv[])
{
		int i;
		struct timeval myTime1,myTime2;
		
		gettimeofday(&myTime1, NULL);

		getpid();

		gettimeofday(&myTime2, NULL);

		printf("%d\n", myTime2.tv_usec-myTime1.tv_usec);

		gettimeofday(&myTime1, NULL);

		for(i=0;i<1000;i++){
				getpid();
		}

		gettimeofday(&myTime2, NULL);

		printf("%d\n", myTime2.tv_usec-myTime1.tv_usec);

		return 0;
}


