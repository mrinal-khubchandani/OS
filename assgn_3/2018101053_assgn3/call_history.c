#include"global.h"

void add_history1(char* home_dir){
    char name[1000];
    char read_buf[10000];
    sprintf(name,"%s/.hist",home_dir);
    int fd=open(name,O_WRONLY|O_CREAT,0700);
    int len = strlen(newline);
    lseek(fd,0,SEEK_END);

    write(fd,newline,len);
    write(fd,"`",1);
    close(fd);

    int fd1=open(name,O_RDWR);
    int size_file=read(fd1,read_buf,100000);
    int j=0;

    for(int i=size_file-1,lines=0;i>=0;i--)
    {
        if(read_buf[i]!='`'){
            continue;
        }
        if(lines==20)
        {
            j=i+1;
            break;
        }
        lines++;
    }

    truncate(name,0);
    close(fd1);

    int fd7=open(name,O_RDWR);
    write(fd7,read_buf+j,size_file-j);
    close(fd7);
}
int number(char **args){
    if(args[1] == NULL){
        return 10;
    }
    int num=0;
    for(int i=0;args[1][i]!='\0';i++){
        num*=10;
        int x = args[1][i] - '0';
        num+=x;
    }
    return num;
}

void history_call(char **args,char * home_dir)
{
    char read_buf[100000];
    int num1;
    num1 = number(args);
    char name[1000];
    // printf("%d",num1);
    sprintf(name,"%s/.hist",home_dir);
    int fd=open(name,O_RDWR);
    int size_file=read(fd,read_buf,100000);
    int j=0;

    for(int i=size_file-1,lines=0;i>=0;i--)
    {
        if(read_buf[i]!='`'){
            continue;
        }
        if(lines==num1)
        {
            j=i+1;
            break;
        }
        lines++;
    }
    for(;j<size_file;j++)
    {
        read_buf[j] == '`' ? printf("\n") : printf("%c",read_buf[j]);
    }

    close(fd);
    return ;
}