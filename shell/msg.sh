#! /bin/bash
#
# msg.sh
# Copyright (C) 2017 jackchuang <jackchuang@echo3>
#
# Distributed under terms of the MIT license.
#

VERSION="4.4.55"
POSTFIX="${VERSION}-net+"

LINUX_FOLDER="/home/jackchuang/share/popcorn-rack"
MSG_FOLDER="/home/jackchuang/share/linux/msg_layer"
HOST=echo

TESTING_MODULE=msg_test.ko
TARGET_MODULE=msg_ib.ko
#TARGET_MODULE=msg_socket.ko
#TARGET_MODULE=msg_dolphin.ko

#ssh $HOST make clean -C $LINUX_FOLDER/msg_layer/
#ssh $HOST make -C $LINUX_FOLDER/msg_layer/
make clean -C msg_layer/
make -C msg_layer/

rm $MSG_FOLDER/$TARGET_MODULE
rm $MSG_FOLDER/$TESTING_MODULE
cp -v msg_layer/$TARGET_MODULE $MSG_FOLDER
cp -v msg_layer/$TESTING_MODULE $MSG_FOLDER
#cp -v msg_layer/msg_socket.ko $MSG_FOLDER

for i in {5..6..1}
#for i in 5 6 7 1
do
    echo "$TARGET_MODULE on echo$i"
    #ssh echo$i cd ~/linux/msg_layer && git pull
    ssh echo$i sudo insmod $MSG_FOLDER/$TARGET_MODULE&
    #ssh echo$i sudo echo 0 > /proc/sys/kernel/hung_task_timeout_secs
    sleep 3
done

echo "connections done!!!"
echo "connections done!!!"
echo "connections done!!!"
#sleep 3

for i in {5..6..1}
#for i in 5 6 7 1
do
    echo "$TESTING_MODULE test on echo$i"
    ssh echo$i sudo insmod $MSG_FOLDER/$TESTING_MODULE
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

sleep 1
#./jack_more_test.sh
##./jack_more_test2.sh
