#! /bin/bash
#
# msg.sh
# Copyright (C) 2017 jackchuang <jackchuang@echo3>
#
# Distributed under terms of the MIT license.
#


#LINUX_FOLDER=/home/jackchuang/linux
LINUX_FOLDER=/mnt/popcorn-rack  
#sudo dmesg -c 

echo "testing start!!!"
echo "testing start!!!"
echo "testing start!!!"
for j in 9                 # testcases
do
    for i in {3..4..1}
    do
        echo "msg_layer2 test$j() on echo$i"
        ssh echo$i sudo echo $j \> /proc/kmsg_test&
        #sleep 1
    done
    
    for i in 1 1 1 1 1 1 1 1 1 1 
    do
        echo "$j"
    done
    sleep 60
done

