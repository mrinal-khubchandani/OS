#include "global.h"

void print_Dir(char *fixed)
{
    char cur[1024];
    getcwd(cur,sizeof(cur));

    int i =0;
    while(fixed[i] == cur[i] && fixed[i] != '\0' && cur[i] != '\0'){
        i++;
    }
    if(fixed[i] != '\0'){
        printf("%s",cur);
    }
    else{
        char name[5000];
        int start = 0;
        name[start++] = '~';
        while(cur[i] != '\0'){
            name[start++] = cur[i++];
        }
        name[start] = '\0';
        printf("%s",name);
    }
}