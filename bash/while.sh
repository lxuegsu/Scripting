#!/bin/bash

i=0
lowbound=(0. 10. 20. 30. 40. 50. 60. 70. 80. 90.)
while [ $i -le 11 ];
do
echo ${lowbound[$i]}
#(( i++ ))
let i++
done

while :
do
echo "endless loop :" 
done

while ture
do
echo "endless loop true" 
done
