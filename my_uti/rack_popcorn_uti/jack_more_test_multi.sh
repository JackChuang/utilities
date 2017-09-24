#! /bin/bash
#
# msg.sh
# Copyright (C) 2017 jackchuang <jackchuang@echo3>
#
# Distributed under terms of the MIT license.
#


#LINUX_FOLDER=/home/jackchuang/linux
LINUX_FOLDER=/mnt/popcorn-rack
RESULT_FOLDER=result12_mimic_WRITE_M
TARGET_NODE=echo5
TEST=12
TEST2=
#TEST=13 // free
#TEST2=14 // ???
#
# 11:	rr READ
# 12:	rr WRITE
# 13: READ
# 14: WRITE
#
# 20: FARM			:12S
# 21: FARM w/ copy	:16S
# 22: FARM2			:14s
#
#
#sudo dmesg -c 

echo "testing start!!!"
echo "testing start!!!"
echo "testing start!!!"

ssh $TARGET_NODE sudo dmesg -c \> /dev/null

for iter in {101..110..1}
do
	ssh $TARGET_NODE rm -r $RESULT_FOLDER$iter
	ssh $TARGET_NODE mkdir -p $RESULT_FOLDER$iter

for t in 4 8 16 32
#for t in 8 16 
do
	for jack in 1
	do
		#for j in 65536 32768 16384 8192 4096 1024 256 64
		#for j in 4096
		if [ $jack -eq 1 ]; then
			ssh $TARGET_NODE rm $RESULT_FOLDER$iter/node5_"$TEST"_"$t"
		else
			ssh $TARGET_NODE rm $RESULT_FOLDER$iter/node5_"$TEST2"_"$t"
		fi
		for j in 64 256 1024 4096 8192 16384 32768 65536
		do
			ssh $TARGET_NODE sudo dmesg -c \> /dev/null
			
			for i in {5..5..1}	# run on echo5
			do
				ssh echo$i sudo dmesg -c \> /dev/null
				echo "msg_layer2 test$j() on echo$i"

				if [ $jack -eq 1 ]; then
					ssh echo$i echo $TEST $j 50000 $t \> /proc/kmsg_test
					ssh echo$i sudo dmesg -c \>\> $RESULT_FOLDER$iter/node"$i"_"$TEST"_"$t"
					#ssh echo$i sudo dmesg -c \>\> $RESULT_FOLDER$iter/node"$i"_"$TEST"_"$t"_"$j"
					#ssh echo$i sudo dmesg -c \| tail -n 1 \>\> $RESULT_FOLDER$iter/node"$i"_"$TEST"_"$t"_"$j"
				else
					ssh echo$i echo $TEST2 $j 50000 $t \> /proc/kmsg_test
					ssh echo$i sudo dmesg -c \>\> $RESULT_FOLDER$iter/node"$i"_"$TEST2"_"$t"
					#ssh echo$i sudo dmesg -c \>\> $RESULT_FOLDER$iter/node"$i"_"$TEST2"_"$t"_"$j"
					#ssh echo$i sudo dmesg -c \| tail -n 1 \>\> $RESULT_FOLDER$iter/node"$i"_"$TEST2"_"$t"_"$j"
				fi
				ssh echo$i echo 0 \> /proc/kmsg_test
			done
		done
	done
	for xx in {1..10..1}
	do
		echo ""
		ssh echo5 echo 0 \> /proc/kmsg_test
	done
done
done
