#!/bin/bash

VERSION="4.4.55"
POSTFIX="${VERSION}-net+"
SRC="/share/jackchuang/linux"

sudo cp ${SRC}/boot/config-${POSTFIX} ${SRC}/boot/initrd.img-${POSTFIX} ${SRC}/boot/System.map-${POSTFIX} ${SRC}/boot/vmlinuz-${POSTFIX} /boot/
sudo rsync -av ${SRC}/modules/${POSTFIX} /lib/modules/
sudo update-grub

