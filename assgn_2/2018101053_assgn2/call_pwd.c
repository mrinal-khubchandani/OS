#include "global.h"

void pwd_call()
{
    char cur[1024];
    getcwd(cur,sizeof(cur));
    printf("%s\n",cur);
}