#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <errno.h>
#include <unistd.h>
#include <sys/stat.h>
#include <sys/syscall.h>
#include <sys/types.h>
#include <dirent.h>
#include <pwd.h>
#include <grp.h>
#include <time.h>

#define PATHNAME_SIZE 512
#define BUF_SIZE      1024
#define handle_error(msg) do {perror(msg); return 1;} while (0)

struct linux_dirent{
		long           d_ino;
		off_t          d_off;
	    unsigned short d_reclen;
		char           d_name[];
};

char *perm2permchar(int n)
{
		int perm[3];
		int i;
		static char perm2[11];

		for(i=0;i<3;i++){
				perm[i] = n % 10;
		}
		for(i=0;i<10;i++) perm2[i] = '-';
		perm2[10] = '\0';
		for(i=3;i>0;i--){
				if(perm[i] == 7){
						perm2[10-3*i] = 'r';
						perm2[11-3*i] = 'w';
						perm2[12-3*i] = 'x';
				}else if(perm[i] == 6){
						perm2[10-3*i] = 'r';
						perm2[11-3*i] = 'w';
                }else if(perm[i] == 5){
                        perm2[10-3*i] = 'r';
                        perm2[12-3*i] = 'x';
                }else if(perm[i] == 3){
                        perm2[11-3*i] = 'w';
                        perm2[12-3*i] = 'x';
                }else if(perm[i] == 4){
                        perm2[10-3*i] = 'r';
                }else if(perm[i] == 2){
                        perm2[11-3*i] = 'w';
                }else if(perm[i] == 1){
                        perm2[12-3*i] = 'x';
                }
		}

		return (perm2);
}

char *uid2uname(uid_t uid)
{
	    struct passwd *pwd ;
        pwd = getpwuid( uid );
        if( pwd )
 	            return( pwd->pw_name );
 	        else
 	        {
 	             static char buf[100] ;
	             sprintf(buf,"%d",uid );
  	             return( buf );
  	        }
}
  	
char *gid2gname(gid_t gid)
{
  	    struct group *grp ;
  	        grp = getgrgid( gid );
  	        if( grp )
  	            return( grp->gr_name );
  	        else
  	        {
  	             static char buf[100] ;
  	             sprintf(buf,"%d",gid );
  	             return( buf );
  	        }
}

int main(int argc, char *argv[])
{
		int fp,nread,bpos;
		char pathname[PATHNAME_SIZE];
		char buf[BUF_SIZE];
		struct linux_dirent *d;
		char d_type;

		memset(pathname, '\0', PATHNAME_SIZE);
		getcwd(pathname, PATHNAME_SIZE);

		fp = open(pathname, O_RDONLY);

		if(fp < 0){
				char err_message[]="ファイルが開けません";
				write(2, err_message, strlen(err_message));
			    write(2, strerror(errno), strlen(strerror(errno)));
				write(2, "\n", 1);
				return 1;
		}

		while(1){
				nread = syscall(SYS_getdents, fp, buf, BUF_SIZE);

				if(nread == -1)
						handle_error("open");
				if(nread == 0)
						break;

				printf("total %d\n", nread);
				for(bpos = 0; bpos < nread;){
						struct stat *stat_buf;
						d = (struct linux_dirent *)(buf + bpos);
						stat(d->d_name, stat_buf);
						d_type = *(buf + bpos + d->d_reclen - 1);
						printf("%s %d %s %s %lld %s %s\n", 
						        perm2permchar(stat_buf->st_mode),
								stat_buf->st_nlink,
								uid2uname(stat_buf->st_uid),
								gid2gname(stat_buf->st_gid),
								stat_buf->st_size,
								ctime(&stat_buf->st_mtime),
								d->d_name);
                        bpos += d->d_reclen;
				}
		}

		close(fp);

		return 0;
}
