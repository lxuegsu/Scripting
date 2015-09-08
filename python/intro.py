#!/usr/local/bin/python3.5

##### simple mathematics
a=2+3
a1=a/2
a2=a//2
a3=a//-2
print(a, a1, a2, a3)

##### complex numbers
b=1+1j*3
b1=complex(3,2)
print(b*b, b1, b.real, b.imag, abs(b))
# float(b), round(b) will give you error

#####
price=55
taxrate=8./100.
c=price*taxrate
#c1=price+_   # _ only works in interactive mode
print(price,taxrate,c)

# string
print("Hello World !")

l1=[1,2,3,5]
l2=[10,20,30]
l3=l1+l2
print ("l1: ",l1, "\t l2: ",l2, "\t l1+l2: ",l3)
