#!/bin/csh

set name = $1
set adress = $2
set sex = $3
set country = $4

set Info = (name adress sex country)
shift Info

echo  name is $argv[1] 
echo  adress is $argv[2]
echo  sex is $argv[3]
echo  country is $4

echo $Info[*]


#set now = '19th June 2010'
#echo $now
date
