#!/bin/bash
echo "bash version: $BASH_VERSION"

echo
#if [ "x`hostname`" = "xliangxue.local" ]
if [ "`hostname`" = "Liang-MacBook-Pro.local" ]
then
echo `hostname`
fi

echo
echo "Test \"NULL\""
if [ ] # NULL is true
then echo "NULL is true !"
else echo "NULL is false !"
fi

echo
echo "Test \"0\""
if [ 0 ] # zero is true
then echo "0 is true !"
else echo "0 is false !"
fi

echo
echo "Test \"1\""
if [ 1 ] # 1 is true
then echo "1 is true !"
else echo "1 is false !"
fi

echo
echo "Test \"-1\""
if [ -1 ] # -1 is true
then echo "-1 is true !"
else echo "-1 is false !"
fi

echo
echo "Test \"false\""
#if : 
if false
then
echo "This is ture ;"
else
echo "This is false ;"
fi

echo
echo "Test \"[ false ]\""
if [ false ] 
then
echo "This is ture ;"
else
echo "This is false ;"
fi

echo
echo "Test \"[ "$false" ]\" \$false is undefined variable !"
if [ "$false" ]
then
echo "\"\$false\" is ture ;"
else
echo "\"\$false\" is false ;"
fi

echo
echo "Test \"[ "$true" ]\" \$true is undefined variable !"
if [ "$true" ]
then
echo "\"\$true\" is ture ;"
else
echo "\"\$true\" is false ;"
fi

echo
comparison="integer"
if echo "Next *if* is part of the comparison for the first *if*."
if [[ $comparison="integer" ]]
	then
		a=2
		b=4
	else
		a=4
		b=2
fi
then
echo "a = $a, b = $b ;"
fi

echo
echo "Test \"cmp\""
if cmp while.sh while.sh
then
echo "while.sh and while.sh are identical !"
else "while.sh and while.sh are different !"
fi

echo
echo "Test \"grep\""
if grep bash while.sh
then
echo "File while.sh contains word \"bash\" !"
else
echo "File while.sh do not contains word \"bash\" !"
fi

echo
echo "Test \"test -z \$1\""
if test -z "$1" 
then
echo "No command line arguments !"
else
echo "First command line arguments is $1 !"
fi

echo
file=/etc/passwd
echo "Test \"test -e \$file\""
#if test -e "$file"
#if [ -e "$file" ]
if [[ -e "$file" ]]
then
echo "$file exist ! !"
else
echo "$file does not exist ! !"
fi

echo
(( 0 ))
echo "Exit status of \"(( 0 ))\" is $?."

echo
(( 1 ))
echo "Exit status of \"(( 1 ))\" is $?."

echo
(( 5 > 4 ))
echo "Exit status of \"(( 5 > 4 ))\" is $?."

echo
(( 5 > 9 ))
echo "Exit status of \"(( 5 > 9 ))\" is $?."

echo
(( 5 - 5 ))
echo "Exit status of \"(( 5 - 5 ))\" is $?."
