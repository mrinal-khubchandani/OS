#include"global.h"

void call_bg(char **parsed)
{
    int pg,num=0,num1;
    for(int i=0;i<strlen(parsed[1]);i++){
       num*=10;
       int x = parsed[1][i]-'0';
       num+=x;
    }
    if(num>size)
    {
        write(2,"Error: Given job number does not exist\n",strlen("Error: Given job number does not exist\n"));
        return;
    }


    pg = runn_proc[num-1].pid;

    if(pg==-1){
        write(2,"Error: Given job number does not exist\n",strlen("Error: Given job number does not exist\n"));
    }
        
    else
    {
        printf("%s\n",runn_proc[num-1].proc_name);
        kill(pg, SIGCONT);
    }
}

