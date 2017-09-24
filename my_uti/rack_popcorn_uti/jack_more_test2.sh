#! /bin/bash
#
# msg.sh
# Copyright (C) 2017 jackchuang <jackchuang@echo3>
#
# Distributed under terms of the MIT license.
#


#LINUX_FOLDER=/home/jackchuang/linux
LINUX_FOLDER=/mnt/popcorn-rack
#RESULT_FOLDER=result4afreusewcs_ib_all
RESULT_FOLDER=result6_farm_real
TARGET_NODE=echo5
TEST=14
#
# 11:	rr READ
# 12:	rr WRITE
# 13: READ
# 14: WRITE
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
	ssh $TARGET_NODE mkdir $RESULT_FOLDER$iter

	for jack in 21
	do
	#for j in 64 128 256 512 1024 2048 4096 8192 16384
	#for j in 16384 65536 8192 4096 2048 1024 512 256 128 64
	#for j in 64 256 1024 2048 4096 8192 8193 16382 16383 16384
	#for j in 8193 8193 8193 8193 8193 8193 8193
	#for j in 8192 8192 8192 8192 8192 8192 8192 16382 16382 16382 16384 16384 16384
	#for j in 8192 8192 8192 8192 8192 8192 8192 16382 16382 16382 16384 16384 16384 65536 65536 65536
	#for j in 65536 32768 16384
	#for j in 4096 16384 32768 65536
	#for j in 8192 4096
	for j in 65536 32768 16384 8192 4096 1024 256 64
	do
		echo "warm-up test$j"
		ssh $TARGET_NODE rm $RESULT_FOLDER$iter/node5"size"$j
		#ssh $TARGET_NODE sudo echo 10 $j \> /proc/kmsg_test	#warmup
		#ssh $TARGET_NODE sudo echo $TEST $j 500000 \> /proc/kmsg_test	#warmup
		#ssh $TARGET_NODE sudo echo $jack $j 500000 \> /proc/kmsg_test	#warmup
		ssh $TARGET_NODE sudo dmesg -c \> /dev/null			#warmup
		for k in {1..1..1}
		do
			echo "$k"
			for i in {5..5..1}	# run on echo5
			do
				ssh echo$i sudo dmesg -c \> /dev/null
				echo "msg_layer2 test$j() on echo$i"
				#ssh echo$i sudo echo 10 $j \> /proc/kmsg_test
				#ssh echo$i sudo echo $TEST $j 500000 \> /proc/kmsg_test
				ssh echo$i sudo echo $jack $j 500000 \> /proc/kmsg_test
				
				ssh echo$i sudo dmesg -c \>\> $RESULT_FOLDER$iter/node$i"size"$j
				#sleep 3
			done
		done

	done
	done
done
