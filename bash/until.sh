#!/bin/bash

i=0
lowbound=(0. 10. 20. 30. 40. 50. 60. 70. 80. 90.)
until [ $i -gt 11 ];
do
echo ${lowbound[$i]}
(( i++ ))
done
