#include"global.h"

void call_cronjob(char **parsed,int len,char *dir)
{
    int p,idx1,idx2;
    int cnt1=1;
    int cnt2=1;
    int cnt3=1;

    for(p=0;p<len;p++){
        cnt1 = strcmp(parsed[p],"-c");
        cnt2 = strcmp(parsed[p],"-t");
        cnt3 = strcmp(parsed[p],"-p");
    }

    if(!(cnt2 || cnt1 || cnt3))
    {
        for(p=0;p<len;p++)
        {
            int x1 = strcmp(parsed[p],"-c");
            int x2 = strcmp(parsed[p],"-t");
            if(x1==0)
                idx1 = p;
            else if(x2==0)
                idx2 = p;
        }

        int h=0;
        char *parsed1[40];
        int xxx = cnt1 | cnt2 | cnt3;
        for(int k=idx1+1;k<idx2;k++)
        {
            parsed1[h]=parsed[k];
            h++;
        }

        int ti=0;
        char tem[100];
        strcpy(tem,parsed[idx2+1]);
        for(int i=0;i<strlen(tem);i++){
            int x3 = tem[i] - '0';
            ti*=10;
            ti+=x3;
        }
        int fr=0;
        strcpy(tem,parsed[idx2+3]);
        for(int i=0;i<strlen(tem);i++){
            int x3 = tem[i] - '0';
            fr*=10;
            fr+=x3;
        }
        Check(parsed1,dir,idx2-idx1-1,ti,fr);
    }

    else{
        write(2,"Error: command not found\n",strlen("Error: command not found\n"));
    }
}
