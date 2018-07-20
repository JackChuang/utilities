#! /bin/bash
#
# input.sh
# Copyright (C) 2017 jackchuang <jackchuang@Jack-desktop>
#
# Distributed under terms of the MIT license.
#

is_flag1=0
is_flag2=1

echo "Input counts: $#"
echo "First arg: $1"
echo "Second arg: $2"
if [ "$1" = "123" ];
then
    echo "123"
elif [ "$1" = "456" ]; then
    echo "456"
else
    echo "not 123/456"
fi

for var in "$@" #input
do
    echo "input: $var"
done

if [ $is_flag1 = 1 ]; then
    echo "is_flag1 is 1"
else
    echo "is_flag1 is not 1"
fi

if [ $is_flag2 = 1 ]; then
    echo "is_flag2 is 1"
else
    echo "is_flag2 is not 1"
fi
