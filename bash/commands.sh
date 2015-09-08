#!/bin/bash

echo "All commands in bash ;"

echo
echo "which bash // find current shell"
echo "whereis bash /// find current shell"
echo "chsh -s csh  /// change shell"
echo "lp myfile   /// print myfile"
echo "abc:defghi" | cut -b 1
echo "abd:defghi" | cut -c 1-3,5-9

echo
echo "abc:defgh:liu:1234:li" | cut -d : -f 1,4
echo "abc:defgh:liu:1234:li" | cut -f 1,2,4,3 -d : 
echo "abc defgh liu 1234 li" | cut -f 1,2,4,3 -d : 
echo "abc defgh liu 1234 li" | cut -f 1,2,4,3 -d : -s 

echo
echo "abc defgh liu 1234 li" | sed 's/liu/abc/g'
echo "abc defgh liu 1234 li" | sed '/^$/d;G;G'
echo "abc defgh liu 1234 li" | sed G

echo
dir1=/usr/local
dir2=/var/spool

pushd $dir1
