#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <pthread.h>

#define BUFSIZE 1024
#define MAX_BACKLOG 512
#define NTHREAD 10

void *server_sub(void *arg)
{
		int sock,sock0 = *(int *)arg;
		struct sockaddr_in client;
		socklen_t len;
		char buf[BUFSIZE];
		len = sizeof(client);
		sock = accept(sock0, (struct sockaddr *)&client, &len);
		if(sock == -1){
				perror("accept");
		}
	
		while(1){
				memset(buf, 0, sizeof(buf));
				if(read(sock, buf, sizeof(buf)) == -1){
						perror("read in server1");
				}
				puts("b");			
				printf("%s\n", buf);
				puts("c");
				if(write(sock, buf, sizeof(buf)) == -1){
						perror("write in server1");
				}
				puts("d");
		}

		close(sock);
}

int tcpechoserver1(int port_number)
{
		int sock0,i,cc;
		struct sockaddr_in addr;
		void *retval;
		pthread_t pth[NTHREAD];

		sock0 = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);

		addr.sin_family = AF_INET;
		addr.sin_port = htons(port_number);
		addr.sin_addr.s_addr = INADDR_ANY;

		if(bind(sock0, (struct sockaddr *)&addr, sizeof(addr)) == -1){
				perror("bind in server1");
				return 1;
		}

		if(listen(sock0, MAX_BACKLOG) == -1){
				perror("listen");
				return 1;
		}

		for(i=0;i<NTHREAD;++i){
				cc = pthread_create(&pth[i], NULL, server_sub, (void *)&sock0);
				if(cc != 0){
						perror("pthread_create");
						return 1;
				}
		}
		for(i=0;i<NTHREAD;++i){
				pthread_join(pth[i], &retval);
		}

		close(sock0);

		return 0;
}

int main(int argc, char *argv[])
{
		if(argc != 2){
				perror("number of argument");
				return 1;
		}

		tcpechoserver1(atoi(argv[1]));

		return 0;
}
