#! /bin/bash
#
# jack_nsdi_proc.sh
# Copyright (C) 2017 jackchuang <jackchuang@echo1>
#
# Distributed under terms of the MIT license.
#

BASE=/home/jackchuang

echo "Input counts: $#"
echo "First arg: $1"

if [ "$#" != "1" ];
then
    echo "bad argu"
	exit
fi

while [ 1 ];
do
	for i in {1..4..1}
	do
		ssh echo$i "cat /proc/popcorn_stat >> $BASE/echo${i}_${1}"
		#ssh echo$i "cat /proc/popcorn_stat"
	done
	sleep 1
done

# del
#for i in {1..4..1}; do ssh echo$i rm echo${i}_numa_page4; done
