#!/bin/bash
echo "bash version: $BASH_VERSION"

echo
let "dec = 32"
echo "decimal number is : $dec ;"

echo
let "oct = 032"
echo "octal number is : $oct ;"

echo
let "hex = 0x32"
echo "hex number is : $hex ;"

echo
let bin1=2#1010
let bin2=2#0101
echo "binary number is : bin1 = $bin1, bin2=$bin2 ;"

if expr $bin1 % $bin2
then echo " true !"
fi

echo
a="b"
b="ABC DECFG"
echo "Variable a is : $a ;"
echo
eval a=\$$a
echo "Variable a after \"eval\" is : $a ;"
