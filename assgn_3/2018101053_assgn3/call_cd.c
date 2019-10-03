#include "global.h"

void cd_call(char **args,char *home_dir)
{
    char* next = args[1];
    if(next==NULL)
    {
        int a = chdir(home_dir);
        if(a!=0)
            perror("invalid");
        return;
    }
    int back = strcmp(next,"-");
    int home = strcmp(next,"~");
    if(back == 0){
        char cur[5000];
        getcwd(cur,5000);
        int a = chdir(previous_dir);
        if(a!=0){
            perror("invalid");
        }
        strcpy(previous_dir,cur);
    }
    else if(home == 0){
        getcwd(previous_dir,5000);
        int a = chdir(home_dir);
        if(a!=0)
            perror("invalid");
    }
    else{
        int a = chdir(next);
        if(a!=0){
            perror("invalid");
        }
    }
}