#! /bin/bash
#
# msg.sh
# Copyright (C) 2017 jackchuang <jackchuang@echo3>
#
# Distributed under terms of the MIT license.
#

#LINUX_FOLDER=/home/jackchuang/linux
LINUX_FOLDER=/home/jackchuang/share/popcorn-rack                                                                                                                
#sudo dmesg -c 

TARGET_MODULE=msg_ib.ko
#TARGET_MODULE=msg_socket.ko
#TARGET_MODULE=msg_dolphin.ko

TESTING_MODULE=msg_test.ko

ssh echo5 make clean -C $LINUX_FOLDER/msg_layer/
ssh echo5 make -C $LINUX_FOLDER/msg_layer/

#for i in {5..6..1}
for i in 5 6 7 1
do
    echo "$TARGET_MODULE on echo$i"
    #ssh echo$i cd ~/linux/msg_layer && git pull
    ssh echo$i sudo insmod $LINUX_FOLDER/msg_layer/$TARGET_MODULE&
    #ssh echo$i sudo echo 0 > /proc/sys/kernel/hung_task_timeout_secs
    sleep 3
done

echo "connections done!!!"
echo "connections done!!!"
echo "connections done!!!"
#sleep 3

#for i in {5..6..1}
for i in 5 6 7 1
do
    echo "$TESTING_MODULE test on echo$i"
    #echo "ssh echo$i sudo insmod $LINUX_FOLDER/msg_layer/$TESTING_MODULE&"
    ssh echo$i sudo insmod $LINUX_FOLDER/msg_layer/$TESTING_MODULE
    #sleep 20
done

echo "testing init done!!!"
echo ""
echo ""
echo ""
sleep 1

echo "testing start!!!"
for j in 99			# skip
#for j in 1 4 1 4 1 4 1 4 1		# testcases
do
    for i in {5..6..1}
    do
        #echo "test$j() on echo$i"
        #ssh echo$i sudo echo $j \> /proc/kmsg_test
        #ssh echo$i sudo dmesg -c \> /dev/null
		echo ""
    done
    echo ""
    echo ""
    echo ""
    echo ""
#    sleep 1
done

sleep 3
#./jack_more_test.sh
##./jack_more_test2.sh
