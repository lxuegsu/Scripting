#!/bin/csh

echo "Start to install libraries ..."

#foreach lib (`cat 32bitlibs.txt`)
#foreach lib (white yellow green blue 1 46 181 wo ai)
foreach lib (`ls `)
	if ( -e $lib ) then
	echo "$lib is a regular file"
	else if ( -d $lib ) then
	echo "$lib is a  directory"
	endif
end

foreach alp (a b c d e)
foreach color (white yellow green blue)
echo "$alp  and $color;"
echo ""
end
end
