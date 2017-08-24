#! /bin/bash
#
# lazy_jack.sh
# Copyright (C) 2017 jackchuang <jackchuang@echo>
#
# Distributed under terms of the MIT license.
#
HOST=echo5
KERN=/home/jackchuang/share/popcorn-rack

function xx() {
	echo ""
	echo ""
	echo "--------------------------------"
	echo "--echo $1---"
	echo "--------------------------------"
	echo ""
	echo ""
}
if [ $1 -eq "1" ]; then
	echo "Will reboot!!!!!!!!!!!"
	echo "Will reboot!!!!!!!!!!!"
	echo "Will reboot!!!!!!!!!!!"
fi

echo "make -j16 -C $KERN"
ssh $HOST make -j16 -C $KERN
xx "make done"
ssh $HOST sudo make modules_install -j16 -C $KERN
xx "modules_install done"
ssh $HOST sudo make install -C $KERN
xx "make install done"

ssh $HOST $KERN/upload.sh
xx "upload_kernel done"
ssh $HOST sudo grub-set-default 1
if [ $1 -eq "1" ]; then
	echo "reboot $HOST"
	ssh $HOST sudo reboot
fi

for i in 6 7 1
do
	ssh echo$i $KERN/update_kernel.sh
	xx "echo$i update_kernel done"
	ssh echo$i sudo grub-set-default 1
	if [ $1 -eq "1" ]; then
		echo "reboot echo$i"
		ssh echo$i sudo reboot
	fi
done
