#! /bin/bash
#
# auto.sh
# Copyright (C) 2018 jackchuang <jackchuang@Jack-desktop>
#
# Distributed under terms of the MIT license.
#

#N=3
#STRING="one two three four"
#arr=($STRING)
#echo ${arr[N-1]}

#./statis_het.py lud_trace lud lud_aarch64
#./statis_het.py eul_trace eul-C eul-C_aarch64
#./statis_het.py stream_trace streamcluster streamcluster_aarch64
#
#./statis_het.py bt_trace BT-C BT-C_aarch64
#./statis_het.py cg_trace CG-C CG-C_aarch64
#./statis_het.py sp_trace SP-C SP-C_aarch64

apps=`ls |grep _trace$` # xxx_trace
for app in $apps; do
    NAME=`echo $app |sed 's/_trace.*//g'`
    echo "  run Jack's analysis tool"
    echo "  trace log file ${app}"
    echo "  x86 src code ${NAME}_x86-64"
    echo "  arm src code ${NAME}_aarch64"
    run="./statis_het.py ${app} ${NAME}_x86-64 ${NAME}_aarch64"
    echo "      -------------------------------------------------------------"
    echo "      $run"
    echo "      -------------------------------------------------------------"
    $run
    echo "$app done"
    echo ""
    echo ""
    echo ""
done

echo "ALL DONE !!!"
echo "ALL DONE !!!"
echo "ALL DONE !!!"
echo ""
echo ""
