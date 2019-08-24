#include "global.h"

void nightswatch_call(char **args)
{
    clear();
    int interrupt = strcmp(args[3],"interrupt");
    int dirty = strcmp(args[3],"dirty");
    char buffer[1000000];
    if(interrupt == 0)
    {
        int num = 0;
        for(int i=0;args[2][i]!='\0';i++){
            num*=10;
            int x = args[2][i] - '0';
            num+=x;
        }

        initscr();
        noecho();
        curs_set(FALSE);
        nodelay(stdscr,TRUE);
        char a = getch();
        int verti=0;
        while(1)
        {
            nodelay(stdscr,TRUE);
            noecho();
            a=getch();
            int fd1 = open("/proc/interrupts",O_RDONLY);
            int f=0;
            
            read(fd1,buffer,1000000);

            char *temp = strtok(buffer," ");
            int hori=0;
            while(temp!=NULL)
            {
                if(f >=14 && f<=17){
                    mvprintw(verti , hori , "CPU %d -- %s\n",f-14,temp);
                    hori+=20;
                }
                f++;
                temp = strtok(NULL," ");
            }

            clock_t t = clock();
            while(((clock()-t)/CLOCKS_PER_SEC)<num)
            {
                nodelay(stdscr,TRUE);
                noecho();
                a = getch();
                if(a!='q'){
                    continue;
                }
                endwin();
                return;
            }
            verti=2+verti;
        }
    }

    if(dirty == 0)
    {
        int num = 0;
        for(int i=0;args[2][i]!='\0';i++){
            num*=10;
            int x = args[2][i] - '0';
            num+=x;
        }

        initscr();
        noecho();
        curs_set(FALSE);
        nodelay(stdscr,TRUE);
        char a = getch();
        int verti=0;
        while(1)
        {
         
            nodelay(stdscr,TRUE);
            noecho();
            a = getch();   
            int fd5 = open("/proc/meminfo",O_RDONLY);

            read(fd5,buffer,1000000);

            int f=0;
            char *stored[1000];
            char *temp = strtok(buffer,"\n");
            while(temp!=NULL)
            {
                stored[f]=temp;
                f++;

                temp = strtok(NULL,"\n");
            }

            int g=0;
            int hori = 0;
            char stri[10000];
            
            char *dirt = strtok(stored[16]," ");

            while(dirt!=NULL)
            {
                if(g == 1){
                    sprintf(stri,"Dirty -- %s ",dirt);
                }
                if(g == 2){
                    mvprintw(verti,hori,"%s%s\n",stri,dirt);
                }
                g++;
                dirt = strtok(NULL," ");
            }

            clock_t t = clock();
            while(((clock()-t)/CLOCKS_PER_SEC)<num)
            {
                nodelay(stdscr,TRUE);
                noecho();
                a = getch();
                if(a!='q'){
                    continue;
                }
                endwin();
                return;
            }
            verti=2+verti;
        }
    }
}