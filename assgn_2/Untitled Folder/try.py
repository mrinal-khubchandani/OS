def swap(arr = []):
	temp = arr[0]
	arr[0] = arr[1]
	arr[1] = temp

arr = []
arr.append(0)
arr.append(1)
arr.append(2)
print(arr)
swap(arr)
print(arr)
