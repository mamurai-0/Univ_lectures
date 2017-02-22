//行数　語数　バイト数　の順に出力する

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <ctype.h>
#include <errno.h>

#define SIZE 1

unsigned long  lcount;
unsigned long  wcount;
unsigned long  ccount;

int main(int argc, char *argv[])
{
		char buf[SIZE],*bufp;
		int fp,rsize,i;

		if(argc != 2){
				char err_message[]="指定すべきファイルの数が正しくありません>    。\n";
				write(2, err_message, strlen(err_message));
				return 1;
        }

		fp = open(argv[1], O_RDONLY);
        
		if(fp < 0){
		        char err_message[]="ファイルが開けません";
		        write(2, err_message, strlen(err_message));
		        write(2, strerror(errno), strlen(strerror(errno)));
		        write(2, "\n", 1);
			    return 1;
	    }

		lcount = wcount = ccount = 0;

		while(1)
		{
				bufp = buf;
				rsize = read(fp, bufp, SIZE);

				if(rsize == 0)
						break;
                
				if(rsize == -1){
						if(errno == EINTR){
								continue;
						}                       char err_message[] = "読み込みエラーが発生しました";
                        write(2, err_message, strlen(err_message));
                        write(2, strerror(errno), strlen(strerror(errno)));
                        write(2, "\n", 1);
                        return 1;
				}

				for(i=0;i<rsize;i++){
						if(bufp[i]=='\n'){
								lcount++;
						}
						if(bufp[i]==' '){
								wcount++;
						}
				}
				ccount += rsize;
		}

		wcount++;
				
		while(1)
		{
				int clos = close(fp);
				if(clos == -1){
						perror(NULL);
				}else{
						break;
				}
		}

		printf("%lu %lu %lu\n", lcount,wcount,ccount);
		
		return 0;
}
