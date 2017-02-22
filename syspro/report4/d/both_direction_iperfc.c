#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <sys/time.h>
#include <pthread.h>

#define BUFSIZE 1000
#define MAX_BACKLOG 512
#define SIZE 32000000

struct timeval before_stoc, before_ctos, after_stoc, after_ctos;
int read_size_stoc=0,read_size_ctos=0;

void *write_thread_c(void *arg)
{
	    int sock1 = *(int *)arg, write_size = 0;
	    char buf[BUFSIZE];

		memset(buf, 'a', BUFSIZE);

		while(1){	
				write_size += write(sock1, buf, BUFSIZE);
				if(write_size >= SIZE) break;
		}

		read(sock1, &read_size_ctos, sizeof(read_size_ctos));
		read(sock1, &before_ctos, sizeof(before_ctos));
		read(sock1, &after_ctos, sizeof(before_ctos));

		return 0;
}

void *read_thread_c(void *arg)
{
		int sock2 = *(int *)arg;
	    char buf[BUFSIZE];

		gettimeofday(&before_stoc, NULL);
		while(1){	
				read_size_stoc += read(sock2, buf, BUFSIZE);
				if(read_size_stoc >= SIZE) break;
		}	
		gettimeofday(&after_stoc, NULL);

		close(sock2);

		return 0;
}

int both_iperfc(int port_number1, int port_number2, char *host)
{
		int sock1,sock2,cc1,cc2,read_size,ans1;
		double ans2;
		struct sockaddr_in addr1,addr2;
		void *retval1,*retval2;
		pthread_t pth1,pth2;
		struct timeval before,after;

		sock1 = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);

		addr1.sin_family = AF_INET;
		addr1.sin_port = htons(port_number1);
		addr1.sin_addr.s_addr = inet_addr(host);

		if(connect(sock1, (struct sockaddr *)&addr1, sizeof(addr1)) < 0){
				perror("connect");
				return 1;
		}
		sock2 = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);

		addr2.sin_family = AF_INET;
		addr2.sin_port = htons(port_number2);
		addr2.sin_addr.s_addr = inet_addr(host);

		if(connect(sock2, (struct sockaddr *)&addr2, sizeof(addr2)) < 0){
				perror("connect");
				return 1;
		}


		cc1 = pthread_create(&pth1, NULL, read_thread_c, (void *)&sock2);
		if(cc1 != 0){
				perror("pthread_create in read");
				return 1;
		}
		cc2 = pthread_create(&pth2, NULL, write_thread_c, (void *)&sock1);
		if(cc2 != 0){
				perror("othread_create in write");
				return 1;
		}
		pthread_join(pth1, &retval1);
		pthread_join(pth2, &retval2);

		if((double)after_stoc.tv_sec-(double)after_ctos.tv_sec+((double)after_stoc.tv_usec-after_ctos.tv_usec)/1000000 > 0){
				read_size = read_size_ctos;
				before = before_ctos;
				after = after_ctos;
		}else{
				read_size = read_size_stoc;
				before = before_stoc;
				after = after_stoc;
		}
	    ans1 = read_size;
		ans2 = (double)after.tv_sec - (double)before.tv_sec + ((double)after.tv_usec - (double)before.tv_usec)/1000000;

		double throughput = 8*(ans1/ans2)/1000000;

		printf("%d %f %f\n", ans1, ans2, throughput);


		close(sock1);
		close(sock2);

		return 0;
}

int main(int argc, char *argv[])
{
		if(argc != 4){
				perror("number of argument");
				return 1;
		}

		both_iperfc(atoi(argv[1]), atoi(argv[2]), argv[3]);

		return 0;
}
