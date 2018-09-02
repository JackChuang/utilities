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


#cat 10t_nl |grep  [0-9][0-9]. |awk '{print$5}'
tasks="
400000
750000
1200000
1500000
2400000
4000000
7500000
10000000
15000000
20000000
"
#cat 10t_nl |grep  [0-9][0-9]. |awk '{print$6}'
times=(
75241
69762
267122
69863
152014
286301
493150
794520
1212328
1775342)

a=0
for i in $tasks; do
    echo "10000000/$i*${times[$a]}/1000" |bc -l
    #echo ${times[$a]}
    let a=a+1
done

array=("123" "444" "666" "777")
for i in "${arr[@]}"; do
   echo "$i"
done

