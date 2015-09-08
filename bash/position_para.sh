#!/bin/bash
echo "bash version: $BASH_VERSION"

echo
echo "The name of the script is $0 or ${0}"
echo "All the command line parameters are $* "
echo "All the command line parameters are $@ "
echo "Total number of command line parameters are $# "

index=1
echo
#for arg in "$*"
#for arg in $*
#for arg in "$@"
for arg in $@
do
	echo "Arguments #$index = $arg "
	let "index+=1"
done


echo
if [ -n $1 ]
then
echo "First parameters is $1 " 
fi

echo
if [ -n $2 ]
then
echo "Second parameters is $2 " 
fi

echo
until [ -z $1 ]
do
echo -n "$1:   "
shift
done

echo
if [ -z ${10} ]  ## return true if ${10} exist
then
exit $EROOR
fi
