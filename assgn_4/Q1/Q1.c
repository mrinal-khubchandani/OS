//#define _POSIX_C_SOURCE 199309L //required for clock
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

int* shar_mem_reg(int size){
    key_t mem_key = IPC_PRIVATE;
    int shm_id;
    shm_id = shmget(mem_key, size, IPC_CREAT | 0666);
    return (int*)shmat(shm_id, NULL, 0);
}

int find_pivot(int arr[],int low,int high)
{
    int pivot = arr[high],i=low-1;
    for(int j=low;j<high;j++)
    {
        if(arr[j] >=pivot){
            continue;
        }
        i++;
        int temp = arr[i];
        arr[i] = arr[j];
        arr[j] = temp;
    }
    int temp = arr[i+1];
    arr[i+1] = arr[high];
    arr[high] = temp;
    return i+1;
}

void insertionSort(int arr[], int start,int end)
{  
    int i, key, j;  
    for (i = start+1; i < end+1; i++) 
    {  
        key = arr[i];  
        j = i - 1;  
  
        while (j >= start && arr[j] > key) 
        {  
            arr[j + 1] = arr[j];  
            j = j - 1;  
        }  
        arr[j + 1] = key;  
    }  
}
 
void normal_quicksort(int arr[],int low,int high)
{
    if(low >= high){
        return;
    }
    if(high - low < 5){
        insertionSort(arr,low,high);
    }
    int pivot = find_pivot(arr,low,high);
    normal_quicksort(arr,0,pivot-1);
    normal_quicksort(arr,pivot+1,high);
}

struct thread_args{
    int left;
    int right;
    int* arr;    
};
void *threaded_quicksort(void* a)
{
    struct thread_args *vals = (struct thread_args*) a;
    int low,high;
    low = vals->left;
    high = vals->right;
    int *arr = vals->arr;
    if(low >= high){
        return NULL;
    }

    if(high - low > 5)
    {
        int pivot = find_pivot(arr,low,high);

        struct thread_args a1;
        a1.left = low;
        a1.right= pivot-1;
        a1.arr = arr;

        pthread_t tid1;
        pthread_create(&tid1,NULL,threaded_quicksort,&a1);

        struct thread_args a2;
        a2.left = pivot+1;
        a2.right= high;
        a2.arr = arr;

        pthread_t tid2;
        pthread_create(&tid2,NULL,threaded_quicksort,&a2);

        pthread_join(tid1,NULL);
        pthread_join(tid2,NULL);

        return NULL;
    }
    insertionSort(arr,low,high);
    return NULL;
}

void multi_process_quicksort(int arr[],int low,int high)
{
    if(low >= high){
        return;
    }
    int pivot = find_pivot(arr,low,high),pid = fork();

    if(!pid)
    {
        if(pivot < 6){
            insertionSort(arr,0,pivot-1);
            _exit(1);
        }
        multi_process_quicksort(arr,0,pivot-1);
        _exit(1);
    }
    else
    {
        int pid1 = fork();

        if(!pid1)
        {
            if(high-pivot<6){
                insertionSort(arr,pivot+1,high);
                _exit(1);
            }
            multi_process_quicksort(arr,pivot+1,high);
            _exit(1);
        }
        else
        {
            int status;
            waitpid(pid,&status,0);
            waitpid(pid1,&status,0);
        }
    }
}

void calcu(long long int n)
{
    //getting shared memory
    int *arr = shar_mem_reg(sizeof(int)*(n+1));
    int arr1[n+10],arr2[n+10];
    long double clk_psec = CLOCKS_PER_SEC;
    clock_t time_fir,time_sec,time_thir,time_four,time_five,time_six;
    for(int i=0;i<n;i++) 
    {
        scanf("%d", arr+i);
    }
    
    time_thir = clock();

    //multiprocess quicksort
    multi_process_quicksort(arr, 0, n-1);

    time_four = clock();
    long double time_process = (long double)(time_four-time_thir)/clk_psec;
    printf("Time taken for quicksort by multiprocess method %Lf\n",time_process);
//	for(int xxx=0;xxx<n;xxx++){
//		printf("%d ",arr[xxx]);
//	}

// --------------------------------------------------------------------------------------------------------------------------

    struct thread_args a;
    a.left = 0;
    a.right = n-1;
    for(int i=0;i<n;i++){
        arr1[i]=*(arr+i);
    }
    a.arr = arr1;

    time_sec = clock();

    //multithreaded quicksort
    pthread_t tid;
    pthread_create(&tid,NULL,threaded_quicksort,&a);
    pthread_join(tid,NULL);

    time_fir = clock();
    long double time_thread = (long double)(time_fir-time_sec)/clk_psec;
    printf("Time taken for quicksort by thread method %Lf\n",time_thread);
	for(int xxx=0;xxx<n;xxx++){
		printf("%d ",arr1[xxx]);
	}
 // -------------------------------------------------------------------------------------------------------------------------
    
    time_five = clock();
    
    //normal quicksort
    for(int i=0;i<n;i++){
        arr2[i]=*(arr+i);
    }
    normal_quicksort(arr2,0,n-1);

    time_six = clock();
    long double time_normal = (long double)(time_six-time_five)/clk_psec;
    printf("Time taken for quicksort by normal method %Lf\n",time_normal);

// --------------------------------------------------------------------------------------------------------------------------
    long double faster_process,faster_thread;
    faster_process = time_process/time_normal;
    printf("Normal quicksort ran %Lf times faster than multiprocess quicksort\n",faster_process);
    faster_thread = time_thread/time_normal;
    printf("Normal quicksort ran %Lf times faster than multithreaded quicksort\n",faster_thread);

    shmdt(arr);
}

int main()
{
    long long int n;
    scanf("%lld",&n);

    calcu(n);

    return 0;
}
