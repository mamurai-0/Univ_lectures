#include <string.h>
#include <unistd.h>
#include <sys/wait.h>
#include <sys/types.h>
#include <sys/uio.h>
#include "parse.h"
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>

#define MAX_PRC 10

int length_prc(process *curr_prc)
{
		if(curr_prc->next == NULL){
				return 1;
		}else{
				return 1 + length_prc(curr_prc->next);
		}
}

void execution(process *curr_prc, char *envp[])
{
		int i,fdr,fdw,len,fdp[2],fdp2[MAX_PRC][2],status,status2,statuss[MAX_PRC];
		pid_t pid,pid2,pid3[MAX_PRC];

		len = length_prc(curr_prc);

		if(len == 1){
				//only one process
				if((pid=fork()) == 0){
						if(curr_prc->input_redirection != NULL){
								fdr = open(curr_prc->input_redirection, O_RDONLY, 0666);
								dup2(fdr, 0);
						}
						if(curr_prc->output_redirection != NULL){
								if(curr_prc->output_option == TRUNC){
										fdw = open(curr_prc->output_redirection, O_WRONLY | O_CREAT | O_TRUNC, 0666);
								}else{
										fdw = open(curr_prc->output_redirection, O_WRONLY | O_CREAT | O_APPEND, 0666);
								}
								dup2(fdw, 1);
						}
						execve(curr_prc->program_name, curr_prc->argument_list, envp);
				}else{
						waitpid(pid, &status, WUNTRACED);
				}
		}else if(len == 2){
				//two process
				if(pipe(fdp)==-1){
						perror("pipe error");
						exit(1);
				}
				if((pid=fork()) == 0){
						close(fdp[0]);
						dup2(fdp[1], 1);
						close(fdp[1]);
						if(curr_prc->input_redirection != NULL){
								fdr = open(curr_prc->input_redirection, O_RDONLY, 0666);
								dup2(fdr, 0);
								close(fdr);
						}
						if(curr_prc->output_redirection != NULL){
								if(curr_prc->output_option == TRUNC){
										fdw = open(curr_prc->output_redirection, O_WRONLY | O_CREAT | O_TRUNC, 0666);
								}else{
										fdw = open(curr_prc->output_redirection, O_WRONLY | O_CREAT | O_APPEND, 0666);
								}
								dup2(fdw, 1);
								close(fdw);
						}
						execve(curr_prc->program_name, curr_prc->argument_list, envp);
				}else{
						curr_prc = curr_prc->next;
						close(fdp[1]);
						if((pid2=fork()) == 0){
								dup2(fdp[0], 0);
								close(fdp[0]);
								if(curr_prc->input_redirection != NULL){
										fdr = open(curr_prc->input_redirection, O_RDONLY, 0666);
										dup2(fdr, 0);
										close(fdr);
								}
								if(curr_prc->output_redirection != NULL){
										if(curr_prc->output_option == TRUNC){
												fdw = open(curr_prc->output_redirection, O_WRONLY | O_CREAT | O_TRUNC, 0666);
										}else{
												fdw = open(curr_prc->output_redirection, O_WRONLY | O_CREAT | O_APPEND, 0666);
										}
										dup2(fdw, 1);
										close(fdw);
								}
								execve(curr_prc->program_name, curr_prc->argument_list, envp);
						}else{
								close(fdp[0]);
								waitpid(pid, &status, WUNTRACED);
								waitpid(pid2, &status2, WUNTRACED);
						}
				}
		}else{
				//multi process
				for(i=0;i<len;i++){
						if(pipe(fdp2[i])==-1){
								perror("pipe error in multi");
								exit(1);
						}
						if((pid3[i]=fork()) == 0){
								if(i!=0){
										 dup2(fdp2[i-1][0], 0);
										 close(fdp2[i-1][0]);
								}
								close(fdp2[i][0]);
								dup2(fdp2[i][1], 1);
								close(fdp2[i][1]);
								if(curr_prc->input_redirection != NULL){
										fdr = open(curr_prc->input_redirection, O_RDONLY, 0666);
										dup2(fdr, 0);
										close(fdr);
								}
								if(curr_prc->output_redirection != NULL){
										if(curr_prc->output_option == TRUNC){
												fdw = open(curr_prc->output_redirection, O_WRONLY | O_CREAT | O_TRUNC, 0666);
										}else{
												fdw = open(curr_prc->output_redirection, O_WRONLY | O_CREAT | O_APPEND, 0666);
										}
										dup2(fdw, 1);
										close(fdw);
								}
								execve(curr_prc->program_name, curr_prc->argument_list, envp);
						}else{
								close(fdp2[i][1]);
								curr_prc = curr_prc->next;
						}
				}
				for(i=0;i<len;i++){
						close(fdp2[i][0]);
						waitpid(pid3[i], &statuss[i], WUNTRACED);
				}
		}
}


int main(int argc, char *argv[], char *envp[])
{
		char s[LINELEN];
		job *curr_job;
		process *curr_prc;

		while(get_line(s, LINELEN)){
				if(!strcmp(s, "exit\n"))break;

				curr_job = parse_line(s);
				curr_prc = curr_job->process_list;
	//			puts("a\n");
				execution(curr_prc, envp);
		//		puts("b\n");
				free_job(curr_job);
		}
		return 0;
}
