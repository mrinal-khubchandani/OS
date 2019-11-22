#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"
#include "userproc.h"
// #include "defs.h"
// #include ""

int main (int argc,char *argv[]){
    printf(1,"PS TEST PROGRAM CALLED\n");
    int su=0;
    struct proc_stat tmp;
    struct proc_stat *p=&tmp;
    if(argc<=1)
    for(int i=0;i<64;i++){
        if(getpinfo(i,p)==0){
            printf(1,"PID: %d | RUNTIME: %d | NUM_RUN: %d | CURRENT_QUEUE: %d |  %d %d %d %d %d",
            p->pid,p->runtime,p->num_run,p->current_queue,p->ticks[0],p->ticks[1],p->ticks[2],p->ticks[3],p->ticks[4]);
            printf(1,"\n");
        }
    }
    else {
        if(getpinfo(atoi(argv[1]),p)==0){
            printf(1,"PID: %d | RUNTIME: %d | NUM_RUN: %d | CURRENT_QUEUE: %d |  %d %d %d %d %d",
            p->pid,p->runtime,p->num_run,p->current_queue,p->ticks[0],p->ticks[1],p->ticks[2],p->ticks[3],p->ticks[4]);
            printf(1,"\n");
        } else {
            printf(1,"Process does not exist\n");
        }
    }
    exit();

}

// struct proc_stat {
//     int pid; // PID of each process
//     int runtime; // Use suitable unit of time
//     int num_run; // number of time the process is executed
//     int current_queue; // current assigned queue
//     int ticks[5]; // number of ticks each process has received at each of the 5 priority queue
// };
