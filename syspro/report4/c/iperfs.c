#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <sys/time.h>

#define BUFSIZE 1024
#define MAX_BACKLOG 512
#define SIZE 32000000

int iperfs(int port_number)
{
		int sock0,sock,read_size=0, ans1;
		double ans2;
		struct sockaddr_in addr,client;
		socklen_t len;
		char buf[BUFSIZE];
		struct timeval before,after;

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

		len = sizeof(client);
		sock = accept(sock0, (struct sockaddr *)&client, &len);

		gettimeofday(&before, NULL);
		while(1){	
				read_size += read(sock, buf, BUFSIZE);
				if(read_size >= SIZE) break;
		}

		gettimeofday(&after, NULL);

		ans1 = read_size;
		ans2 = (double)after.tv_sec - (double)before.tv_sec+((double)after.tv_usec - (double)before.tv_usec)/1000000;

		write(sock, &ans1, sizeof(ans1));
		write(sock, &ans2, sizeof(ans2));
		
		close(sock);	
		close(sock0);

		return 0;
}

int main(int argc, char *argv[])
{
		if(argc != 2){
				perror("number of argument");
				return 1;
		}

		iperfs(atoi(argv[1]));

		return 0;
}
