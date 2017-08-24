#! /bin/bash
#
# msg.sh
# Copyright (C) 2017 jackchuang <jackchuang@echo3>
#
# Distributed under terms of the MIT license.
#


#LINUX_FOLDER=/home/jackchuang/linux
LINUX_FOLDER=/mnt/popcorn-rack
RESULT_FOLDER=result9999_test_M
TARGET_NODE=echo5
TEST=22
TEST2=99
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

#for iter in {101..110..1}
for iter in {101..101..1}
do
	ssh $TARGET_NODE rm -r $RESULT_FOLDER$iter
	ssh $TARGET_NODE mkdir -p $RESULT_FOLDER$iter

	for jack in 1
	#for jack in 1 2
	do
		#for j in 65536 32768 16384 8192 4096 1024 256 64
		for j in 64 256 1024 4096 8192 16384 32768 65536
		#for j in 65536
		do
			if [ $jack -eq 1 ]; then
				ssh $TARGET_NODE rm $RESULT_FOLDER$iter/node5_$TEST"size"$j
			else
				ssh $TARGET_NODE rm $RESULT_FOLDER$iter/node5_$TEST2"size"$j
			fi
			ssh $TARGET_NODE sudo dmesg -c \> /dev/null
			for k in {1..1..1}
			do
				echo "$k"
				for i in {5..5..1}
				#for i in 5 6 7 1
				do
					ssh echo$i sudo dmesg -c \> /dev/null
					echo "msg_layer2 test$j() on echo$i"
				done

				for i in {5..5..1}
				#for i in 5 6 7 1
				do
					if [ $jack -eq 1 ]; then
						ssh echo$i echo $TEST $j 500000 \> /proc/kmsg_test
						#sleep 16
						ssh echo$i sudo dmesg -c \| tail -n 1 \>\> $RESULT_FOLDER$iter/node$i"_"$TEST"size"$j
					else
						ssh echo$i echo $TEST2 $j 500000 \> /proc/kmsg_test
						#sleep 16
						ssh echo$i sudo dmesg -c \| tail -n 1 \>\> $RESULT_FOLDER$iter/node$i"_"$TEST2"size"$j
					fi
					#sleep 3
				done

			done
			sleep 1
		done
		echo "next test"
		sleep 10
	done
done
