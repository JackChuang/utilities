#! /bin/bash
#
# msg.sh
# Copyright (C) 2017 jackchuang <jackchuang@echo3>
#
# Distributed under terms of the MIT license.
#

LINUX_FOLDER=/home/jackchuang/popcorn-rack
MSG_FOLDER=/home/jackchuang/share/linux/msg_layer

TESTING_MODULE=msg_test.ko

make clean -C $LINUX_FOLDER/msg_layer/
make -C $LINUX_FOLDER/msg_layer/

rm $MSG_FOLDER/$TESTING_MODULE
cp -v msg_layer/msg_test.ko $MSG_FOLDER

for i in {1..2..1}
#for i in {5..6..1}
#for i in 5 6 7 1
do
    echo "$TESTING_MODULE on echo$i"
	ssh echo$i sudo rmmod msg_test.ko
	ssh echo$i sudo insmod $MSG_FOLDER/$TESTING_MODULE&
done

echo "driver done!!!"
echo "driver done!!!"
echo "driver done!!!"

for i in {1..2..1}
#for i in 5 6 7 1
do
	echo ""
done

echo ""
echo ""
echo ""

