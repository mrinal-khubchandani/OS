import json

with open('input.json') as f:
	d=json.load(f)

dat=json.dumps(d)
data=eval(dat)
m=len(data["letters"])
n=data["states"]
arr = []
for i in range(0,n+1):
	lt=[]
	for j in range(0,m):
		lt.append([])
	arr.append(lt)
mapp={}
# make map of letters and index
for i in range(0,m):
	mapp[data["letters"][i]]=i
for i in range(0,len(data["t_func"])):
	for j in range(0,len(data["t_func"][i][2])):
		# print(type(mapp[data["t_func"]][i][1]))

		arr[data["t_func"][i][0]][mapp[data["t_func"][i][1]]].append(data["t_func"][i][2][j])

# n=data["states"]
def power(args):
	ans=0
	for x in range(0,len(args)):
		# print(type(args[x]))
		ans+=int(pow(2,x)*args[x])

	return ans
DFA=[]
final_states=[]
for i in range(0,2**n):
	lt=[]
	for j in range(0,m):
		lt.append(0)
	DFA.append(lt)
for i in range(0,2**n):
	num=i
	lt=[]
	while num:
		lt.append(num%2)
		num=int(num/2)
	while len(lt) <n:
		lt.append(0)
	print(lt)	
	print(len(lt))

	
	for k in range(0,m):
		ans=[]
		for j in range(0,n):
			ans.append(0)
		for j in range(0,n):
			if lt[j]==1:
				for p in arr[j][k]:
					ans[p]=1;


			
		DFA[i][k]=power(ans);
	flag=False
	for j in range(0,n):
		if lt[j] ==1:
			if (j) in data["final"]:
				flag=True
	if flag:
		final_states.append(i)				

DFA_FUNC =[]
for i in range(0,2**n):
	for j in range(0,m):
		lt=[]
		lt.append(i)
		lt.append(data["letters"][j])
		lt.append(DFA[i][j])
		DFA_FUNC.append(lt)
# print(DFA_FUNC)
ans=[]
ans.append({
	"states"  : 2**n,
	"letters" : data["letters"],
	"t_func"  :	DFA_FUNC,
	"start"   : data["start"],
	"final"   : final_states
	})

with open('output.json','w') as outfile:
	json.dump(ans,outfile)
