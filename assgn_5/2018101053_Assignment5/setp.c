#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"
// #include "proc.h"


int main (int argc,char *argv[]){
    // printf(1,"TEST PROGRAM CALLED\n");
    if(argc<3) printf(1,"enter 2 arguments");
    int pid = atoi(argv[1]);
    int prio = atoi(argv[2]);
    if(prio<0||prio>100){
        printf(1,"invalid priority\n");
    } else {
        printf(1,"SETTING PRIORITY OF %d TO %d\n",pid,prio);
        set_priority(pid,prio);
    }
    // printf(1,"EXITING FROM TEST PROGRAM, %d\n",su);
    exit();
}
