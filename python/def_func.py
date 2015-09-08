#!/usr/local/bin/python3.5

def fib(n):
	a, b = 0, 1
	i=1
	while i<n:
		print (a, b, end=' ')
		a = a+b
		b = b+a
		i=i+1
	print()

fib(10)

f = fib
f(20)
f(1)
print (f(1))


### function 2
def fib2(n):
	a=1
	results=[]
	i=1
	while  i<n:
		results.append(a)  ## calls a method of list object "results", same as results = results + [a]
		a=a+a
		i=i+1
	return results

f10=fib2(10)
print (f10)
