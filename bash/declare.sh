#!/bin/bash
echo "bash version: $BASH_VERSION"

echo
myls () {
	ls $1
}

# list the function above
echo "Test declare -f func:"
#declare -f myls
declare -f
echo
echo "Test typeset -f func:"
#typeset -f myls
typeset -f

echo
declare -r var_pi=3.1415926    ## like const in C
echo "declare readonly variable : $var_pi"


echo
declare -i var_int=5
echo "declare int : $var_int"

echo
declare -a var_array=( 1 2 3 4 5 6 "three" "abc" )
declare -i index=0
while [ $index -lt 8 ]
do
echo "declare array : ${var_array[$index]}"
let "index+=1"
done
