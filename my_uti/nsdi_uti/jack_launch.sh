#! /bin/bash
#
# jack_launch.sh
# Copyright (C) 2017 jackchuang <jackchuang@echo1>
#
# Distributed under terms of the MIT license.
#
BASE=/home/jackchuang/

echo "Input counts: $#"
echo "First arg: $1"
echo "Second arg: $2"

if [ "$#" != "2" ];
then
	echo "bad argu"
	exit
fi

echo "running......"

for i in {1..4..1}
do
	ssh echo$i "echo \"====>\" >> ${BASE}/echo${i}_${2}"
done
#`exec $1`
$1

for i in {1..4..1}
do
	ssh echo$i "echo \"<====\" >> ${BASE}/echo${i}_${2}"
done

echo "done!!!!!!"
