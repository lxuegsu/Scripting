#!/bin/bash
echo "bash version: $BASH_VERSION"

echo
select name in John Aiden He Larry Edward
do
echo
echo "You select: $name"
echo
break
done

choice_of()
{
	select vegetable
		do
			echo
			echo "Select vegetable: $vegetable ;"
			echo
			break
		done
}

choice_of beans rice carrots radishes

exit 0
