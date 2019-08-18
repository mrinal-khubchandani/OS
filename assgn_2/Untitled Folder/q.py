import json

with open('input.json') as inp_file:
	temp=json.load(inp_file)

temp1=json.dumps(temp)
inp=eval(temp1)

equi={}
input_char=len(inp["letters"])
no_of_states=inp["states"]
pp = 2**no_of_states
a = []
ans = []
convert = []
final_states= []
new_t_func = []
length = len(inp["t_func"])
i=0
j=0

while i < (input_char):
    equi[inp["letters"][i]]=i
    i+=1

i=0
j=0
while i < (no_of_states+1):
    lst=[[] for j in  range(input_char)]
    a.append(lst)
    i+=1

i=0
j=0
while i < (length):
    while j < (len(inp["t_func"][i][2])):
        a[inp["t_func"][i][0]][equi[inp["t_func"][i][1]]].append(inp["t_func"][i][2][j])
        j+=1
    i+=1

i=0
j=0
while i < (pp):
    lst=[0 for j in range(input_char)]
    convert.append(lst)
    i+=1

i=0
j=0
k=0
l=0
p=0
y=0
for i in range(pp):
    temp_num=i
    lst=[]
    while temp_num:
        new_num = int(temp_num/2)
        rem = temp_num%2
        lst.append(rem)
        temp_num=new_num
    while len(lst)!=(no_of_states):
        lst.append(0)

    ans=[0 for j in range(no_of_states)]

    for k in range(input_char):
        for l in range(no_of_states):
            if lst[l]==1:
                for p in a[l+1][k]:
                    ans[p]=1
                    
        fin=0
        for y in range(0,len(ans)):
            fin+=int(2**y)
        convert[i][k]=fin
	
    cond=0
    for j in range(no_of_states):
        if lst[j]==1:
            if (j+1) in inp["final"]:
                cond=1
    if cond:
        final_states.append(i)

for i in range(pp):
    for j in range(input_char):
        lst=[]
        lst.append(i)
        lst.append(inp["letters"][j])
        lst.append(convert[i][j])
        new_t_func.append(lst)

output_fin = []
output_fin.append({
	"states"  : pp,
	"letters" : inp["letters"],
	"t_func"  : new_t_func,
	"start"   : inp["start"],
	"final"   : final_states
	})

with open('output.json','w') as out_file:
	json.dump(output_fin,out_file)
