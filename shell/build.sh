#!/bin/bash

#make -j99
#sudo make modules_install -j99
for i in {3..5..1}
do
	ssh echo$i "sudo make install -C /mnt/popcorn-rack"
	ssh echo$i "sudo reboot"
	for j in {1..10..1}
	do
		echo "done on echo$i"
	done
done
