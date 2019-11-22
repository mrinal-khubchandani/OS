#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "userproc.h"

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int sys_waitx(void){  // taken from https://stackoverflow.com/questions/53383938/pass-struct-to-xv6-system-call
  int *wtime,*rtime;
  if(argptr(0,(char**)&wtime,sizeof(int))<0||argptr(1,(char**)&rtime,sizeof(int))<0) return -2;
  return waitx(wtime, rtime);
}

int sys_set_priority(void){
  int pid,priority;
  if(argptr(0,(char**)&pid,sizeof(int))<0||argptr(1,(char**)&priority,sizeof(int))<0) return -2;
  return set_priority(pid,priority);
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int sys_getpinfo(void){
  int pid; struct proc_stat *ps;
  if(argptr(0,(char**)&pid,sizeof(int))<0||argptr(1,(char**)&ps,sizeof(struct proc_stat))<0) return -2;
  return getpinfo(pid,ps);
}

int sys_getticks(void){
  return ticks;
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}
