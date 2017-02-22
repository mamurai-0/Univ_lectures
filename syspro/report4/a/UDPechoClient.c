#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>


#define BUFSIZE 1024

int udpechoclient(int port_number, char * host)
{
		int sock;
		struct sockaddr_in addr;
		socklen_t recvlen = sizeof(addr);
		char buf_send[BUFSIZE], buf_recv[BUFSIZE];

		sock = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
		if(sock == -1){
				perror("sock in client");
				close(sock);
				return 1;
		}

		addr.sin_family = AF_INET;
		addr.sin_port = htons(port_number);
		addr.sin_addr.s_addr = inet_addr(host);

		while(scanf("%s", buf_send) != EOF){
				if(sendto(sock, buf_send, sizeof(buf_send), 0, (struct sockaddr *)&addr, sizeof(addr)) < 0){
						perror("sendto in client");
						return 1;
				}
				if(recvfrom(sock, buf_recv, sizeof(buf_recv), 0, (struct sockaddr *)&addr, &recvlen) < 0){
						perror("recvfrom in client");
						return 1;
				}
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

		udpechoclient(atoi(argv[1]), argv[2]);

		return 0;
}
			
