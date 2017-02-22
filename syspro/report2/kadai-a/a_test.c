#include <sys/time.h>
#include <sys/types.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>

int main()
{
		struct timeval *tv,*tv2;
		tv = malloc(sizeof(struct timeval));
		tv2 = malloc(sizeof(struct timeval));

		gettimeofday(tv, NULL);

		getpid();

		gettimeofday(tv2,NULL);

		printf("%ld\n", tv2->tv_sec - tv->tv_sec);

		return 0;
}

