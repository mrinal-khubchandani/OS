#include "global.h"

void echo_call(char **args,int time,int freq)
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
        printf("%s\n",args[1]);
        if(freq-time*(i+1)>=time){
            continue;
        }
        sleep(freq-time*(i+1));
    }
}