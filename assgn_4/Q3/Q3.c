#include<stdio.h>
#include<stdlib.h>
#include<unistd.h>
#include<string.h>
#include<pthread.h>

int n,m,k;
int finished_count;
int totalRiders;

struct values{
    pthread_mutex_t lock2;
    char cabtype[100];
    int ridingtime;
    int waitingtime;
    int left;
    int ind;
};

struct values data[10000];

typedef struct Cabs{
    pthread_mutex_t lock;
    pthread_t thread_ID;
    int ind;
    int no_of_riders;
    int state;
    int type;
    int ridetime;
}cab;

struct Cabs taxis[1000];

typedef struct pay{
    pthread_mutex_t lock1;
    pthread_t thread_ID;
    int ind;
    int state;
}pay_server;

struct pay paymentservers[1000];

void* paymentServer(void *args)
{ 
    struct pay *paydata = (struct pay *)args;
    int pay_idx,rider_idx;
    pay_idx = paydata->ind;

    while(1)
    {
        for(int i=0;i<m;i++)
        {
            pthread_mutex_lock(&data[i].lock2);
            if(data[i].left!=1){
                pthread_mutex_unlock(&data[i].lock2);
                continue;
            }
            if(paymentservers[pay_idx].state==0)
            {
                paymentservers[pay_idx].state=1;
                data[i].left=0;
                rider_idx = data[i].ind;
                
                pthread_mutex_unlock(&data[i].lock2);
                sleep(2);

                printf("Payment done by rider %d through payment server number %d\n",rider_idx,pay_idx);
                fflush(stdout);
                ++finished_count,paymentservers[pay_idx].state=0;
                break;
            }
            pthread_mutex_unlock(&data[i].lock2);
        }
    }
}

void* check(void *args)
{
    char type[100];
    struct values *vals = (struct values*) args;

    strcpy(type,vals->cabtype);
    int rdtime,wttime,rid_ind;
    rdtime = vals->ridingtime;
    wttime = vals->waitingtime;
    rid_ind = vals->ind;

    printf("Rider %d is waiting to be allocated a cab\n",rid_ind);
    
    time_t start;
    time_t end;
    time(&start);

    while(1)
    {
        double diff;
        time(&end);
        diff = difftime(end,start);
        if(diff>wttime)
        {
            totalRiders--;
            printf("Rider %d did not find any cab\n",rid_ind);
            pthread_exit(NULL);
        }

        if(strcmp(type,"Premier")==0)
        {
            for(int i=0;i<n;i++)
            {
                pthread_mutex_lock(&taxis[i].lock);

                int index = taxis[i].ind;
                if(taxis[i].state==0)
                {
                    taxis[i].type=0,taxis[i].no_of_riders=1,taxis[i].state=1,taxis[i].ridetime=rdtime;

                    printf("Rider %d got premier ride in cab number %d\n",rid_ind,index);
                    fflush(stdout);
                    int sl_time;
                    sl_time = taxis[index-1].ridetime;
                    pthread_mutex_unlock(&taxis[i].lock);
                    
                    sleep(sl_time);

                    printf("Rider %d dropped off at the location by cab number %d\n",rid_ind,index);
                    fflush(stdout);
                    
                    taxis[index-1].state=0,taxis[index-1].ridetime=0,taxis[index-1].no_of_riders=0,data[rid_ind-1].left=1;

                    pthread_exit(NULL);
                    break;
                }
                pthread_mutex_unlock(&taxis[i].lock);
            }
        }

        else
        {
            for(int i=0;i<n;i++)
            {
                pthread_mutex_lock(&taxis[i].lock);

                int index = taxis[i].ind;
                int x_check = rdtime%10;
                if(taxis[i].no_of_riders==1 && (taxis[i].state==1) && taxis[i].type==1)
                {
                    int sl_time;
                    taxis[i].ridetime= rdtime;
                    taxis[i].type=1,taxis[i].no_of_riders=2,taxis[i].state=1;


                    printf("Rider %d got pool ride in cab number %d\n",rid_ind,index);
                    fflush(stdout);

                    sl_time = taxis[index-1].ridetime;
                    taxis[index-1].ridetime=0;
                    pthread_mutex_unlock(&taxis[i].lock);

                    sleep(sl_time);

                    printf("Rider %d dropped off at the location by cab number %d \n",rid_ind,index);
                    fflush(stdout);
                    --taxis[index-1].no_of_riders;
                    data[rid_ind-1].left=1;
                    if(taxis[index-1].no_of_riders==1)
                    {
                        taxis[index-1].state=1,taxis[index-1].type=1;
                    }
                    else
                        taxis[index-1].state=0;

                    pthread_exit(NULL);
                    break;
                }
                pthread_mutex_unlock(&taxis[i].lock);
            }
            for(int i=0;i<n;i++)
            {
                int index = taxis[i].ind;
                pthread_mutex_lock(&taxis[i].lock);

                if(taxis[i].state==0)
                {
                    taxis[i].type=1,taxis[i].no_of_riders=1,taxis[i].state=1;
                    taxis[i].ridetime=rdtime;

                    printf("Rider %d got pool ride in cab number %d\n",rid_ind,index);
                    fflush(stdout);
                    int sl_time = taxis[rid_ind-1].ridetime;
                    pthread_mutex_unlock(&taxis[i].lock);
                    
                    sleep(sl_time);
                    taxis[index-1].ridetime=0;
                    
                    printf("Rider %d dropped off at the location by cab number %d\n",rid_ind,index);
                    fflush(stdout);

                    --taxis[index-1].no_of_riders;
                    data[rid_ind-1].left=1;
                    if(taxis[index-1].no_of_riders)
                    {
                        taxis[index-1].state=1,taxis[index-1].type=1;
                    }
                    else
                    {
                        taxis[index-1].state=0;
                    }
                    pthread_exit(NULL);
                    break;
                }

                pthread_mutex_unlock(&taxis[i].lock);
            }
        }
    }
}

int main()
{
    char type[100];
    scanf("%d %d %d",&n,&m,&k);
    totalRiders=m;

    pthread_t riders[m];
    pthread_t payment[k];

    srand(time(0));
    for(int i=0;i<n;i++)
    {
        taxis[i].ridetime=0,taxis[i].type=-1,taxis[i].state=0,taxis[i].no_of_riders=0;
        taxis[i].ind=i+1;

        pthread_mutex_init(&taxis[i].lock,NULL);
    }

    for(int i=0;i<k;i++)
    {
        paymentservers[i].state=0;
        paymentservers[i].ind=i+1;
        pthread_mutex_init(&paymentservers[i].lock1,NULL);
    }

    for(int j=0;j<m;j++)
    {
        int r = rand()%2;
        char ch1[] = "Premier",ch2[] = "Pool";
        int rdtime = rand()%10;
        int wttime = rand()%10;
        if(r==0)
            strcpy(type,ch1);
        else
            strcpy(type,ch2);

        pthread_mutex_init(&data[j].lock2,NULL);

        data[j].ridingtime = rdtime,data[j].waitingtime = wttime,data[j].ind = j+1,data[j].left = 0;
        strcpy(data[j].cabtype,type);

        pthread_create(&riders[j],NULL,check,&data[j]);
    }
    
    for(int i=0;i<k;i++)
    {
        pthread_create(&payment[k],NULL,paymentServer,&paymentservers[i]);
    }

    while(finished_count!=totalRiders)
    {
    }
}
