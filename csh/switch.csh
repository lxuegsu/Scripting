#!/bin/csh

set input = $1

switch ("$input")
	case 1.1 :
	echo "a case is 10000"
	breaksw
	case 1.2 :
	echo "b case is 1000"
	breaksw
	default :
	echo "by default number is numnber"
	endsw
