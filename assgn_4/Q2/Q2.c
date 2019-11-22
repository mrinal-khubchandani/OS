
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <wait.h>
#include <limits.h>
#include <fcntl.h>
#include <time.h>
#include <pthread.h>
#include <inttypes.h>
#include <math.h>
#define ll long long
#define lop(m,n,p) for(int m=n;m<p;m++)
#define wh while(1)

int pivot(int *arr,int l,int r)
{
    int piv=arr[r],temp,k=l-1,j;
      for(j=l;j<=r;j++)
      {
        if(arr[j]<piv)
          {  k++;
        temp=arr[j];
        arr[j]=arr[k];
        arr[k]=temp;}
      }
      temp=arr[k+1];
      arr[k+1]=arr[r];
      arr[r]=temp;

      return k+1;

}
void normal_quicksort(int *arr,int l,int r)
{
    if(l>r)return;
    else if(r-l<4)
    {
     int a[5], mi=INT_MAX, mid=-1;
        for(int i=l;i<r;i++)
        {
            int j=i+1; 
            for(;j<=r;j++)
                if(arr[j]<arr[i] && j<=r) 
                {
                    int temp = arr[i];
                    arr[i] = arr[j];
                    arr[j] = temp;
                }
        }
     return;   
    }
    int piv= pivot(arr,l,r);
        
    normal_quicksort(arr,l,piv-1);
    normal_quicksort(arr,piv+1,r);
     
}

int chef[100][2];
int table[100];
void biryani_ready(int k);
int student[100][2];
int n;
void ready_to_serve_table(int w);
int students_time[100];
pthread_mutex_t tablelock[100],stdlock[100];
int num_std;
int tslots[100];

void student_in_slot(int g);

void* fill_chefs_vessel(void* arg)
{
    
    int* k = (int*) arg;
    
    printf("Robot chef %d started preparing food\n",*k);    
    //int *k=*k;
    int w = 2+rand()%4;
    int r = 1+rand()%10;
    int p = 25+rand()%26;
    
    printf("Robot Chef %d is preparing %d vessels of Biryani\n",*k,r);
    sleep(w);
    printf("Robot Chef %d has prepared %d vessels of Biryani and is waiting to empty all the vessels to resume cooking\n",*k,r);
    chef[*k][0] = r;
    chef[*k][1] = p;
    printf("Robot Chef %d completed preparing food\n",*k);
    
    biryani_ready(*k);
    return NULL;
}
void biryani_ready(int k)
{
    while(chef[k][0])
    {
        
        lop(i,1,n+1)
        {
            pthread_mutex_lock(&tablelock[i]);
            if(chef[k][0]>0)
            {   
                if(table[i]==0)
                {
                    
                    chef[k][0]--;

                    printf("Robot Chef %d is refilling Serving Container of Serving Table %d\n",k,i);
                    printf("Serving table %d entering Serving Phase\n",i);
                    printf("Serving Container of Table %d is refilled by Robot Chef %d; Table %d resuming serving now\n",i,k,i);
                    table[i]=chef[k][1];
                }
            }
            pthread_mutex_unlock(&tablelock[i]);
            if(chef[k][0]==0)
                break;
        }
    }
    printf("All the vessels prepared by Robot Chef %d are emptied.Robot chef %d can resume cooking now.\n",k,k);
    fill_chefs_vessel(&k);  
    
}
void* table_slots(void* arg)
{
    int* k = (int*) arg;
    
    wh
    {
        int f=0;
        while(table[*k]!=0)
        {
            if(tslots[*k]!=0)
                f=1;
            
            else
            {
                tslots[*k] = 1 + rand()%10;
                if(tslots[*k]>table[*k])
                    tslots[*k]=table[*k];
                table[*k]-=tslots[*k];
                printf("Serving Table %d is ready to serve with %d slots\n",*k,tslots[*k]);
               
                ready_to_serve_table(*k);
            }
            f=1;
         
        }
        if(f==1)
        printf("Serving Container of Table %d is empty, waiting for a refill to resume serving phase",*k); 
    }
}
void ready_to_serve_table(int w)
{
    
    while(tslots[w]>0)
    {
       
        lop(i,1,num_std+1)
        {
            pthread_mutex_lock(&stdlock[i]);
           
            if(student[i][0]==1)
            {
                if(tslots[w]!=0)
                    {
           
                          student[i][1]=w;
                        student[i][0]=2;
                      printf("Student %d assigned a slot on the serving table %d and waiting to be served\n",i,w);
                        student_in_slot(i);
                        tslots[w]--;
                    }
            }
            pthread_mutex_unlock(&stdlock[i]);
            if(tslots[w]==0)
                break;
            
            
        }
    }
}

void* wait_for_slot(void* arg)
{
    int* k = (int*) arg;
    printf("Student %d is waiting to be allocated a slot on the serving table\n",*k);
    student[*k][0]=1;

}

void student_in_slot(int g)
{    
    student[g][0]=3;
    printf("Student %d on serving table %d has been served.\n",g,student[g][1]);
  
}

int main()
{
    srand(time(0));
    int m;
    int p;
    int k;
   
    scanf("%d",&m);
    scanf("%d",&n);
    scanf("%d",&num_std);
    lop(i,0,num_std)
    {
        students_time[i] = rand()%60;
    }
    normal_quicksort(students_time,0,num_std-1);
    lop(i,0,num_std)
    {
        printf("%d ",students_time[i]);
    }
    printf("\n");
   
    lop(i,1,n+1)
    {
        if(pthread_mutex_init(&tablelock[i],NULL)!=0)
        {
            printf("Unable to create mutex lock.\nProgram failed.\n");
            exit(1);
        }
    }
   
    lop(i,1,num_std+1)
    {
        if(pthread_mutex_init(&stdlock[i],NULL)!=0)
        {
            printf("Unable to create mutex lock.\nProgram failed.\n");
            exit(1);
        }
    }
    pthread_t tid;
    int qw[100];
    int er[100];
    int we[100];
    int s=0;
   
    lop(i,1,m+1)
    {
        qw[i]=i;
        pthread_create(&tid, NULL, &fill_chefs_vessel, &qw[i]);
    }
    
   
    lop(i,1,n+1)
    {
        er[i]=i;
        pthread_create(&tid, NULL, &table_slots, &er[i]);
    }
   
    lop(i,0,num_std)
    {
        sleep(students_time[i]-s);
        s=students_time[i];
        we[i]=i;
        we[i]++;
        printf("Student %d has arrived\n",we[i]);
        pthread_create(&tid, NULL, &wait_for_slot, &we[i]);
    } 

    wh
    {
        int asd=0;
        for(int i=1;i<=num_std;i++){
            if(student[i][0]==3)
                asd++;
        }
   
        if(asd!=num_std)
            sleep(5);
        else
        {
            exit(1);
        }
        sleep(5);
    }
}