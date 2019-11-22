# OS: ASSIGNEMNT 5

# executing the program
- `make clean; make qemu-nox SCHEDULER=MLFQ` for MMLFQ scheduler
- `make clean; make qemu-nox SCHEDULER=PRIORITY` for priority scheduler
- `make clean; make qemu-nox SCHEDULER=FCFS` for FCFS scheduler
- `make clean; make qemu-nox SCHEDULER=DEFAULT` or `make clean; make qemu-nox` for default scheduler


# IMPLEMENTATION:


## waitx syscall:
- `rtime` added in proc struct that gets updated every clock in `uprtime` defined in `proc.c`
- wtime and rtime gets updated everytime wait syscall is called, refer to `proc.c/waitx`
- rest of `waitx` is same as `wait`
- TEST PROGRAM: `mytime <command>`
- command executed using waitx and prints how much time the program waited and how much time it ran

## getpinfo syscall:
- `int getpinfo(int pid,struct *proc_stat p)` implemented in `proc.c`, populates the struct proc_stat with process `pid`'s values
- struct is a subset of proc, and is defined in `userproc.h` file.

## FCFS 
- in proc.c, first a RUNNABLE process is found: `p`
- then the list of processes is searched till to see if another runnable process has a lower `ctime` than the current selected program `p`
- `p` is executed repeatedly till it finishes and the process repeats

## PRIORITY
- similar to FCFS, first a RUNNABLE process `p` is found
- then I search all processes to find a higher priority process, or a process with same priority with lower `rtime` to ensure round robin execution
- selected process executes, then next process is choosen.

## MLFQ
- fake queues are used (queue isnt actually implemented but program runs assuming it is).
- each process has a `pqlvl` that ranges from 0-4 (inclusive) that says which queue process belongs to.
- the process with lowest `pqlvl` is choosen and that process runs,
- the process has a `time-slice` that it can not exceed, if it does, it get pre-empted and the process is pushed to lower priority queue (`p->pqlvl++`)
- above is done by checking at every tick in `trap.c` file, and calling `yield` if the process excedes its time-sclice.
- also if a process waits for too long between runtime, or its overall waittime is too high, it gets a higher priority and hence gets executed.
- if a process consumes too much CPU-time, it gets pushed down to a lower queue.

### rest of the details are either commented in the code, or are trivial as their implemntation doesnt have a huge impact.

## graph:
- uncomment graph data section from testprog1, this outputs csv data which is copy pasted in file called "data"
- run `script.py` from same folder where data is implemented.
- please run on jupyter if possible for more clean output.
- to run on terminal: `python3 script.py`.
- dependancies: `csv`, `matplotlib`.

### to use diff-file to see changes, please use vim.


# REPORT

- FCFS took relatively lesser time than all other processes.
- This was probably because each process finishes executing and then exits, so most of the cpu time is spent on executing the processes.
- The default round robin took lesser time than PBS which took less time than MLFQ
- This is probably because of the selection criteria in PBS, and in MLFQ the time slices force-preempt a process if it exceeds its time limit.

- Hence FCFS finishes processes one by one completely, default round robin finishes then together, PBS finishes processes that have same priority together but first finishes all of same priority and then goes to a lower one. MLFQ makes sure the shorter processes finish quickly and no process takes too long (time slicing). also MLFQ unlike PBS makes sure processes dont wait for too long as they get pushed up the queue.

> Mrinal Khubchandani
