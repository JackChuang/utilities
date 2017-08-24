#! /bin/bash
#
# forloop.sh
# Copyright (C) 2017 jackchuang <jackchuang@Jack-desktop>
#
# Distributed under terms of the MIT license.
#


s=0
i=1
for (( i=4*1024; i<=8*1024*1024; i=i*2 ))
do
    echo -n "$i "
    #s=$(($s+$i))
done
echo ""


for animal in dog cat elephant
do
    echo "There are ""$animal""s.... "
done
echo ""


array=(500 600 700)
arraylength=${#array[@]}
for (( i=1; i<${arraylength}+1; i++ ));
do
    for seq in `seq 1 4`; do 
        echo $i " / " ${arraylength} " : " ${array[$i-1]}
    done
    echo ""
done
