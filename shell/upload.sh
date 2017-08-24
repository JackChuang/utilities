#!/bin/bash

VERSION="4.4.55"
POSTFIX="${VERSION}-net+"
DEST="/share/jackchuang/linux"

mkdir -p ${DEST}/boot ${DEST}/modules/ ${DEST}/msg_layer

#rsync -av /lib/modules/${POSTFIX} ${DEST}/modules
cp -v /boot/config-${POSTFIX} /boot/initrd.img-${POSTFIX} /boot/System.map-${POSTFIX} /boot/vmlinuz-${POSTFIX} ${DEST}/boot/
cp -v msg_layer/msg_ib.ko msg_layer/msg_socket.ko ${DEST}/msg_layer

