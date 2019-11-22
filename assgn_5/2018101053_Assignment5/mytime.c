#include "types.h"
#include "stat.h"
#include "user.h"
#include "fs.h"
// #include "proc.h"

int main (int argc,char *argv[]){
    printf(1,"CALLED\n");
	int w=0,r=0;
	int pid = fork();
	if (pid == 0) {	
  		exec(argv[1], argv);
    	printf(1, "exec %s failed\n", argv[1]);
    } 
    else waitx(&w,&r);
 	// else wait();
    printf(1, "Wait Time = %d\n Run Time = %d\n",w,r); 
    
    //int su=0;
    //for(int i=0;i<100000000;i++) if(i%11234==0){
    //    su+=i;
    //};
    //printf(1,"su = %d\n",su);
    //
    exit();
}
