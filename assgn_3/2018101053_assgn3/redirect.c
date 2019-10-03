#include"global.h"

void call_redirection(char **parsed,int len)
{
    char *new_parsed[40];
    int iter1,iter2;
    int iter3,iter4;
    iter1=-1;
    iter2=-1;
    iter3=-1;
    iter4=-1;
    int fl1=0,fl2=0,fl3=0,fl4=0;

    for(int x=len-1;x>=0;x--)
    {
        if(strcmp(parsed[x],">")==0 && fl1 == 0)
        {
            iter1=x;
            fl1 = 1;
        }
        if(strcmp(parsed[x],"<")==0 && fl2 == 0)
        {
            iter2=x;
            fl2 = 1;
        }
        if(strcmp(parsed[x],">>")==0 && fl4 == 0)
        {
            iter4=x;
            fl4 = 1;
        }
    }

    int new_flag=0;
    if(iter4>iter1)
    {
        iter1=iter4;
        new_flag=1;
    }

    for(int x=0;x<len;x++)
    {
        int cmp1 = strcmp(parsed[x],">");
        int cmp2 = strcmp(parsed[x],"<");
        int cmp3 = strcmp(parsed[x],">>");
        if(cmp1 && cmp2 && cmp3){
            continue;
        }
        iter3=x;
        break;
    }

    int fd,fd1,fd2,fd3,fd4;
    for(int i=0;i<len;i++){
        if(i >= iter3){
            new_parsed[i] = NULL;
            break;
        }
        new_parsed[i] = parsed[i];
    }
    fd4 = open(".1.txt",O_WRONLY | O_CREAT ,0777);
    write(fd4,"hello",strlen("hello"));
    int x7 = 0;
    if(iter1!=-1)
    {
        if(new_flag==0){
            fd = open(parsed[iter1+1], O_WRONLY | O_CREAT | O_TRUNC , 0777);
            char buf6[100];
            sprintf(buf6,"%d",x7++);
            write(fd4,buf6,strlen(buf6));
        }
        else
        {
            fd = open(parsed[iter1+1], O_WRONLY | O_CREAT , 0777);
            lseek(fd,0,SEEK_END);
            char buf6[100];
            sprintf(buf6,"%d",x7++);
            write(fd4,buf6,strlen(buf6));
        }
        fd1=dup(1);
        dup2(fd,1);
    }
    if(fl2)
    {
        fd2 = open(parsed[iter2+1], O_RDONLY | O_CREAT , 0777);
        fd3=dup(0);
        char buf6[100];
        sprintf(buf6,"%d",x7++);
        write(fd4,buf6,strlen(buf6));
        dup2(fd2,0);
    }

    close(fd4);
    int pid11 = fork();

    if(pid11==0)
    {
        int fd8 = open(".1.txt",O_WRONLY|O_CREAT,0777);
        write(fd8,"child start",strlen("child start"));
        close(fd8);
        execvp(new_parsed[0],new_parsed);
        write(fd8,"child end",strlen("child end"));
        close(fd8);
        exit(0);
    }
    else if(pid11>0)
    {
        int status;
        waitpid(pid11,&status,WUNTRACED);
    }
    if(fl2){
        dup2(fd3,0);
    }
        
    if(iter1!=-1){
        dup2(fd1,1);
    }
}
