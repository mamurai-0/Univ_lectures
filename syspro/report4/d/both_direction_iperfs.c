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

struct timeval before_ctos, after_ctos;

void *write_thread_s(void *arg)
{
	    int sock, sock2 = *(int *)arg, write_size = 0;
		struct sockaddr_in client;
		socklen_t len;
	    char buf[BUFSIZE];

		puts("waa");
	    len = sizeof(client);
		sock = accept(sock2, (struct sockaddr *)&client, &len);

		puts("wab");
		if(sock == -1){
				perror("accept");
		}

		puts("wa");
		while(1){	
				write_size += write(sock, buf, BUFSIZE);
				if(write_size >= SIZE) break;
		}

		puts("wb");
		return 0;
}

void *read_thread_s(void *arg)
{
		int sock, sock1 = *(int *)arg, read_size_ctos = 0;
		struct sockaddr_in client;
		socklen_t len;
	    char buf[BUFSIZE];

	    len = sizeof(client);
		sock = accept(sock1, (struct sockaddr *)&client, &len);

		if(sock == -1){
				perror("accept");
		}

		puts("ra");
		gettimeofday(&before_ctos, NULL);
		while(1){	
				read_size_ctos += read(sock, buf, BUFSIZE);
				if(read_size_ctos >= SIZE) break;
		}
		gettimeofday(&after_ctos, NULL);

		puts("rb");
		write(sock, &read_size_ctos, sizeof(read_size_ctos));
		write(sock, &before_ctos, sizeof(before_ctos));
		write(sock, &after_ctos, sizeof(after_ctos));

		puts("rc");
		close(sock);
		
		return 0;
}

int both_iperfs(int port_number1, int port_number2)
{
		int sock1,sock2,cc1,cc2;
		struct sockaddr_in addr1,addr2;
		void *retval1,*retval2;
		pthread_t pth1,pth2;

		sock1 = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
		sock2 = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);

		addr1.sin_family = AF_INET;
		addr1.sin_port = htons(port_number1);
		addr1.sin_addr.s_addr = INADDR_ANY;
		addr2.sin_family = AF_INET;
		addr2.sin_port = htons(port_number2);
		addr2.sin_addr.s_addr = INADDR_ANY;


		if(bind(sock1, (struct sockaddr *)&addr1, sizeof(addr1)) == -1){
				perror("bind in server1");
				return 1;
		}

		if(listen(sock1, MAX_BACKLOG) == -1){
				perror("listen");
				return 1;
		}
		
		if(bind(sock2, (struct sockaddr *)&addr2, sizeof(addr2)) == -1){
				perror("bind in server1");
				return 1;
		}

		if(listen(sock2, MAX_BACKLOG) == -1){
				perror("listen");
				return 1;
		}


		puts("a");
		cc1 = pthread_create(&pth1, NULL, read_thread_s, (void *)&sock1);
		puts("b");
		if(cc1 != 0){
				perror("pthread_create in read");
				return 1;
		}
		cc2 = pthread_create(&pth2, NULL, write_thread_s, (void *)&sock2);
		puts("c");
		if(cc2 != 0){
				perror("othread_create in write");
				return 1;
		}
		puts("d");
		pthread_join(pth1, &retval1);
		puts("e");
		pthread_join(pth2, &retval2);

		close(sock1);
		close(sock2);

		return 0;
}

int main(int argc, char *argv[])
{
		if(argc != 3){
				perror("number of argument");
				return 1;
		}

		both_iperfs(atoi(argv[1]), atoi(argv[2]));

		return 0;
}
