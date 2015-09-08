#!/bin/csh
echo "Script name is : $0"
echo
echo $$  ## process identification number

echo
echo "integer calculation !"
set count = 9
@ count = $count + 5
@ count++
echo "Calculated count is: $count"

@ count /= 5
echo "Calculated count /= 5 is: $count"

@ octrem = $count % 4
echo "Calculated count % 4 is: $octrem"
echo


echo "logical calculation !"
set a = 2
@ x = ($a < 5 || 20 <= $a)
echo "logical variable x: $x"
