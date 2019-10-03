#include "global.h"

void pwd_call(int time,int freq)
{
    int y;
    if(time!=-1 && freq!=-1)
    {
        y = (freq/time);
    }
    else{
        time=0;
        freq=0;
        y=1;
    }
    for(int i=0;i<y;i++)
    {
        sleep(time);
        char cur[1024];
        getcwd(cur,sizeof(cur));
        printf("%s\n",cur);
        if(freq-time*(i+1)>=time){
            continue;
        }
        sleep(freq-time*(i+1));
    }
}