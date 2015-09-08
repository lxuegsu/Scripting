#!/bin/bash
echo "bash version: $BASH_VERSION"

fun2(){
echo "call function: fun2();"
caller 0
return $GOOD
}

myls () {
	ls $1
		fun2
	caller 0
return $GOOD
}

# list the function above
#declare -f myls
declare -f

echo
echo "Test my func \"myls\" "
for dir in ./ ../ 
do
if [ -d $dir ]
then myls $dir
else echo "$dir is not a directory !"
fi
done
