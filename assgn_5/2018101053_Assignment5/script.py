import csv
import matplotlib.pyplot as plt
# %matplotlib inline
# UNCOMMENT IF RUNNING ON JUPYTER
# please try to run on jupyter if possible

data=list(csv.reader(open("data","r")))
X = [int(x[0]) for x in data]
YS=[]
for j in range(1,len(data[0])): YS.append([int(y[j]) for y in data])

fig = plt.figure()

ax = fig.add_axes([0,0,1,1])

pid=0
for Y in YS:
    ax.plot(X,Y, label=str(pid), marker='o', linestyle='dashed')
    pid+=1

ax.axhline(y=0, color='k')
ax.axvline(x=0, color='k')
ax.legend()
plt.show()
#print(X)
#print(YS)
