#! /bin/bash
#
# msg.sh
# Copyright (C) 2017 jackchuang <jackchuang@echo3>
#
# Distributed under terms of the MIT license.
#


#sudo dmesg -c 


echo "testing start!!!"
for j in 1                  # testcases
do
    #for i in {3..5..1}
    for i in 5 4 3
    do
        echo "msg_layer2 test$j() on echo$i"
        ssh echo$i sudo echo 7 \> /proc/kmsg_test&
    done
    echo ""
    echo ""
    echo ""
    echo ""
done


