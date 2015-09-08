#!/bin/bash
echo "bash version: $BASH_VERSION"

echo
echo "Hit a key, then hit enter;"
read keypress
case "$keypress" in
	[[:lower:]] ) echo "Lower case: $keypress" ;;
	[[:upper:]] ) echo "Upper case: $keypress" ;;
	[0-9] ) echo "Numbers: $keypress" ;;
esac


echo
var="abc"
case "$var" in
abc) echo "\$var=abc" ;;
xyz) echo "\$var=xyz" ;;
esac
