#!/bin/sh

F1=0
F2=1
Fn=0
echo $F1;
echo $F2;
#for (( i=0; i<10; i++))
i=0
while [ $i -lt 10 ]
do
#let "$Fn = $F1 + $F2"
((Fn=F1+F2))
echo "$Fn";
((F1=F2));
((F2=Fn));
((i++))
done
