#include"global.h"

void call_overkill()
{
    for(int h=0;h<size;h++)
    {
        if(runn_proc[h].pid==-1)
        {
            continue;
        }
        kill(runn_proc[h].pid,9);
    }
}
