#!/bin/bash

read -p "Please enter your first name :" firstname
read -p "Please enter your last name :" lastname
echo "Your name is : $lastname $firstname."

i=0
while [ $i -le 11 ];
do
echo "xxxxx"
(( i++ ))
done

L1=line1
L2=line2
File=if.sh
{
read $L1
read $L2
} < $File

echo "Line 1 in file $File is $line1"
echo "Line 2 in file $File is $line2"
