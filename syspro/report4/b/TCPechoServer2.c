#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <sys/time.h>
#include <time.h>
#include <netdb.h>

#define BUFSIZE 1024
#define MAX_BACKLOG 512
#define MAX_SOCK 10

int tcpechoserver2(int port_number)
{
		int sock0,i;
		struct sockaddr_in addr;
		fd_set fds,org_fds;
		struct timeval waitval;
		char buf[BUFSIZE];

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

		memset(buf, 0, sizeof(buf));
		FD_ZERO(&org_fds);
		FD_SET(sock0, &org_fds);

		while(1){
				waitval.tv_sec = 2;
				waitval.tv_usec = 0;

				memcpy(&fds, &org_fds, sizeof(org_fds));

				select(FD_SETSIZE, &fds, NULL, NULL, &waitval);
				for(i=0;i<FD_SETSIZE;i++){
						if(FD_ISSET(i, &fds)){
								printf("fds %d start\n", i);
								if(i == sock0){
										int new_sock;
										socklen_t len = sizeof(addr);
										new_sock = accept(sock0, (struct sockaddr *)&addr, &len);
										if(new_sock == -1){
												perror("accept");
												return 1;
										}else if(new_sock > FD_SETSIZE-1){
												new_sock = -1;
												perror("too many socket");
										}
										FD_SET(new_sock, &org_fds);
								}else{
										int read_size;
										read_size = read(i, buf, sizeof(buf));
										if(read_size <= 0){
												perror("read");
												close(i);
												FD_CLR(i, &org_fds);
										}else{
												buf[read_size] = '\0';
												write(i, buf, strlen(buf));
										}
								}
								printf("fds %d end\n", i);
						}
				}
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

		tcpechoserver2(atoi(argv[1]));

		return 0;
}
