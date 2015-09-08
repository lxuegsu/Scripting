#!/bin/csh
echo "Script name is : $0"
echo
echo $$  ## process identification number

echo
if ($?name) then
echo "name defined !"
else
echo "name is not defined !"
endif

echo
set name = Liang
set color = blue
echo "$name like color $color";

echo
if ($?name) then
echo "name defined !"
else
echo "name is not defined !"
endif

unset name
unset color

echo
set colors = (blue yellow green red pink)
foreach color ($colors)
	echo current color is : $color
end

echo
echo "Total number of elements in array colors is: $#colors"
echo "All elements of variable are: $colors[*]"
#echo "The last element of variable is:" $colors[$]
echo "The first to the third elements are: $colors[1-3]"
echo "The first element to the last element are: $colors[1-]"
