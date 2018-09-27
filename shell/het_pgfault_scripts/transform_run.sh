#! /bin/sh
#
# transform.sh
# Copyright (C) 2018 jackchuang <jackchuang@Jack-desktop>
#
# Distributed under terms of the MIT license.
#

echo "First script: preprocess(only required oneshot) + run analyzer"
echo "1-1.  parse regular trace to Rob's format"
echo "1-2.  run Rob's analyzer"
echo "2.    run Jack's analyzer (./auto_het.py)"

apps=`ls |grep _trace$` # xxx_trace

echo "========================="
echo "transform to rob's format"
echo "========================="
for app in $apps; do
    echo "awk $app"
    echo "TODO: manually trun on and off"
    echo "TODO: manually trun on and off"
    echo "TODO: manually trun on and off"
    #awk '{print substr($4,1,length($4)-1) "\t" $6 "\t" $7 "\t" $8 "\t" $9 "\t" $10 "\t" $11}' $app | grep -v "EVENTS" > ${app}_rob_format
    echo "TODO: manually remove dirst 11 lines!!!"
    echo "TODO: manually remove dirst 11 lines!!!"
    echo "TODO: manually remove dirst 11 lines!!!"
done
    
echo "========================="
echo "run rob's analyzer (auto)"
echo "========================="
for app in $apps; do
    NAME=`echo $app |sed 's/_trace.*//g'`
    echo "  run robs analysis tool"
    echo "  analying x86 bin ${NAME}_x86-64"
    echo "  analying arm bin ${NAME}_aarch64"
    echo "  analying trace ${app}_rob_format"
    echo "      -------------------------------------------------------------"
    echo "      Running: ./run-pat-analysis.sh -i ${app}_rob_format -a ${NAME}_aarch64 -x ${NAME}_x86-64"
    echo "      -------------------------------------------------------------"
    ./run-pat-analysis.sh -i ${app}_rob_format -a ${NAME}_aarch64 -x ${NAME}_x86-64
done 

#echo "==========================="
#echo "run rob's analyzer (manual)"
#echo "==========================="
#./run-pat-analysis.sh -i bt_trace_rob_format -a BT-C_aarch64 -x BT-C
#./run-pat-analysis.sh -i cg_trace_rob_format -a CG-C_aarch64 -x CG-C
#./run-pat-analysis.sh -i eul_trace_rob_format -a euler3d_cpu_aarch64 -x euler3d_cpu
#./run-pat-analysis.sh -i lud_trace_rob_format -a lud_aarch64 -x lud
#./run-pat-analysis.sh -i sp_trace_rob_format -a SP-C_aarch64 -x SP-C
#./run-pat-analysis.sh -i stream_trace_rob_format -a streamcluster_aarch64 -x streamcluster
#echo "Done!"

echo "========================"
echo "run Jack's main analyzer"
echo "========================"
./auto_het.sh
echo "Done!"


echo "==========================="
echo "ALL DONE !!!"
echo "ALL DONE !!!"
echo "ALL DONE !!!"
echo "==========================="
