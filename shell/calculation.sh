#! /bin/sh
#
# calculation.sh
# Copyright (C) 2016 jack <jack@Jack-desktop>
#
# Distributed under terms of the MIT license.
#


#cat /proc/stat | sed '2,$d'
#cat /proc/stat | sed '2,2'

#grep 'cpu ' /proc/stat | awk '{usage=($2+$3+$4)*100/($2+$3+$4+$5+$6+$7+$8)} END {print usage}'
#3.24059

#grep 'cpu ' /proc/stat | awk '{usage=($2+$3+$4)*100/($2+$3+$4+$5+$6+$7+$8)} END {print usage "%"}'
#3.24059%


a1=shell grep 'cpu ' /proc/stat | awk '{usage=($2+$3+$4)*100/($2+$3+$4+$5+$6+$7+$8)} END {print usage}'
#echo $a1

sleep 1

a2=shell grep 'cpu ' /proc/stat | awk '{usage=($2+$3+$4)*100/($2+$3+$4+$5+$6+$7+$8)} END {print usage}'
#echo $a1

SUM = 'expr $a2 - $a1'

echo "a2 - a1 = $SUM"
echo $SUM
