#! /bin/bash
#
# lazy_jack.sh
# Copyright (C) 2017 jackchuang <jackchuang@echo>
#
# Distributed under terms of the MIT license.
#
HOST=echo
#KERN=/home/jackchuang/share/popcorn-rack
KERN=/home/jackchuang/popcorn-rack
CPU=32

function xx() {
	echo ""
	echo ""
	echo "--------------------------------"
	echo "--echo $1 $2---"
	echo "--------------------------------"
	echo ""
	echo ""
}
if [ $2 -eq "1" ]; then
	echo "Will reboot!!!!!!!!!!!"
	echo "Will reboot!!!!!!!!!!!"
	echo "Will reboot!!!!!!!!!!!"
fi

if [ $1 -eq "1" ]; then
	echo "make -j$CPU -C $KERN"
	ssh $HOST make -j$CPU -C $KERN
	xx "make done"
	ssh $HOST sudo make modules_install -j$CPU -C $KERN
	xx "modules_install done"
	ssh $HOST sudo make install -j$CPU -C $KERN
	xx "make install done"

	ssh $HOST $KERN/upload.sh
	xx "upload_kernel done"
	#ssh $HOST sudo grub-set-default 1
	#	echo "reboot $HOST"
	#	ssh $HOST sudo reboot
else
	echo "skipped compilation"
fi

#for i in 1 2 3 4
for i in 6 7
#for i in 6 7 1
do
#	ssh echo$i $KERN/update_kernel.sh
	ssh echo$i ~/update_kernel.sh
	xx "echo$i update_kernel done"
	ssh echo$i sudo grub-set-default 1

	# exceptions
#	if [ $i -eq "2" ]; then
#		ssh echo$i sudo grub-set-default 2
#	fi
#	if [ $i -eq "4" ]; then
#		ssh echo$i sudo grub-set-default 0
#	fi

	if [ $2 -eq "1" ]; then
		echo "reboot echo$i"
		ssh echo$i sudo reboot
	else
		echo "no reboot"
	fi
done
