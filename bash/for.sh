#!/bin/bash

echo "bash version: $BASH_VERSION"

for a   ## will read the command line argument $@
do
echo $a
done

#for file in  `cat files`
for file in  1 2 3 4 5 .. 100 
do
echo $file
done

i=0
for ((i=1; i<100; i=i+1))
do
echo $i
done
