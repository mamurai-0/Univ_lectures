#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#define BUFSIZE 1024

int tcpechoclient(int port_number, char *host)
{
		int sock;
		struct sockaddr_in addr;
		char buf_send[BUFSIZE], buf_recv[BUFSIZE];

		sock = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
		if(sock == -1){
				perror("sock in client");
				close(sock);
				return 1;
		}

		addr.sin_family = AF_INET;
		addr.sin_port = htons(port_number);
		addr.sin_addr.s_addr = inet_addr(host);
	    if(connect(sock, (struct sockaddr *)&addr, sizeof(addr)) < 0){
				perror("connect");
				return 1;
		}
	
		while(scanf("%s", buf_send) != EOF){
				puts("a");
				int w;
				w = write(sock, buf_send, sizeof(buf_send));
	            printf("write=%d\n", w);
				if(w < 0){
						perror("write");
						return 1;
				}
				puts("b");
				int r;
				r = read(sock, buf_recv, sizeof(buf_recv));
				printf("read=%d\n", r);
				if(r < 0){
						perror("read");
						return 1;
				}
				puts("c");
				printf("%s\n", buf_recv);
				memset(buf_send, 0, sizeof(buf_send));
				memset(buf_recv, 0, sizeof(buf_recv));
		}

		close(sock);

		return 0;
}

int main(int argc, char *argv[])
{
		if(argc != 3){
				perror("number of argument");
				return 1;
		}

		tcpechoclient(atoi(argv[1]), argv[2]);

		return 0;
}
