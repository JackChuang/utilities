#! /bin/bash
#
# parse.sh
# Copyright (C) 2017 jackchuang <jackchuang@echo4>
#
# Distributed under terms of the MIT license.
#


for k in 4
do
	for i in 64 128 256 512 1024 2048 4096 8192 16384
	do
		cat node$k"size"$i |sed 's/.*spent \([0-9]*.[0-9]*\) s/\1/g' >  node$k"size"$i"_data"
	done
done
