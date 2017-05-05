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

TARGET_MODULE=msg_ib.ko


TESTING_MODULE=msg_layer_test.ko

ssh echo3 make clean -C $LINUX_FOLDER/msg_layer/
ssh echo3 make -C $LINUX_FOLDER/msg_layer/

for i in {3..4..1}
do
    echo "$TARGET_MODULE on echo$i"
    #ssh echo$i cd ~/linux/msg_layer && git pull
    ssh echo$i sudo insmod $LINUX_FOLDER/msg_layer/$TARGET_MODULE&
    #ssh echo$i sudo echo 0 > /proc/sys/kernel/hung_task_timeout_secs
    sleep 10
done

echo "connections done!!!"
echo "connections done!!!"
echo "connections done!!!"
echo "connections done!!!"
echo "connections done!!!"
echo "connections done!!!"
echo "connections done!!!"
sleep 10

for i in {3..4..1}
do
    echo "$TESTING_MODULE test on echo$i"
    #echo "ssh echo$i sudo insmod $LINUX_FOLDER/msg_layer/$TESTING_MODULE&"
    ssh echo$i sudo insmod $LINUX_FOLDER/msg_layer/$TESTING_MODULE&
    #sleep 20
done

echo "testing init done!!!"
echo ""
echo ""
echo ""
sleep 10

echo "testing start!!!"
for j in 9                  # testcases
do
    for i in {3..4..1}
    do
        echo "test$j() on echo$i"
        ssh echo$i sudo echo $j \> /proc/kmsg_test&
    done
    echo ""
    echo ""
    echo ""
    echo ""
    sleep 60
done

