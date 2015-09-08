#!/bin/bash

echo "bash version: $BASH_VERSION"

# If the result is true, then return 0. If the result is false, then return 1.
test "x`hostname`" = "xliangxue.local"
if [ !$? ]
then
echo "host name is liangxue.local;"
else
echo "host name is not liangxue.local;"
fi

#if [ -f if.sh ]
if [ -e if.sh ]
then
echo "file if.sh exist !"
else
echo "file if.csh does not exist !"
fi

if [ -d `pwd` ]
then
echo "dir `pwd` exist !"
else
echo "dir `pwd` does not exist !"
fi

#if [ -n "" ] ## If length of str1 is not 0, return true. Otherwise false.
if [ -n "test" ]
then
echo "The length of string is not 0;"
else
echo "The length of string is 0;"
fi


echo ""
echo ""
echo ""
echo ""
echo "Usages:"
echo  '[ -d DIR ]	如果DIR存在并且是一个目录则为真'
echo  '[ -f FILE ]	如果FILE存在且是一个普通文件则为真'
echo  '[ -z STRING ]	如果STRING的长度为零则为真'
echo  '[ -n STRING ]	如果STRING的长度非零则为真'
echo  '[ STRING1 = STRING2 ]	如果两个字符串相同则为真'
echo  '[ STRING1 != STRING2 ]	如果字符串不相同则为真'
echo  '[ ARG1 OP ARG2 ]	ARG1和ARG2应该是整数或者取值为整数的变量，OP是-eq（等于）-ne（不等于）-lt（小于）-le（小于等于）-gt（大于）-ge（大于等于）之中的一个'
