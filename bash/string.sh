#!/bin/bash
echo "bash version: $BASH_VERSION"
echo

if [ $# -eq 0 ]
then
echo "ERROR: total number of args is $# !!!"
echo "USAGE: $0 FILENAME"
exit 0
fi

string="hello everyone, my name is Andrew Xue"
echo
echo ${#string}
echo
echo `expr "$string" : '.*'`
