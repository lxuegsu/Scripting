#!/bin/csh

echo "exec macro with multiple centrality bins ..."
echo ""

set ichi2 = 4.6
set lowbound = (0. 10. 20. 30. 40. 50. 60. 70. 80. 90.)
set highbound = (10. 20. 30. 40. 50. 60. 70. 80. 90. 100.)

set i = 1

while ($i < 11)
echo $lowbound[$i]
#@ i = $i + 1
@ i++
end
