#! /bin/bash
#
# jack_split.sh
# Copyright (C) 2017 jackchuang <jackchuang@Jack-desktop>
#
# Distributed under terms of the MIT license.
#


#split
#
    for file in bk  btb  epb  ftb  numa-bfs  numa-page
    do
        for z in 2 3 4;
        do
            ./split.py $file/echo1_${file}${z};
        done
    done
#


#get head and tail time
#for ECHO in 1 2 3 4
#do
    if [ -e result_sent ]
    then 
        rm result_sent
    fi
    
    if [ -e result_recv ]
    then 
        rm result_recv
    fi

    for file in bk  btb  epb  ftb  numa-bfs  numa-page
    do
        for z in 2 3 4
        do
            for ta in sent recv
            do
                echo "$file echo1 t${z} " >> result_$ta
                #echo "${file}/echo1_${file}${z}_${ta}"
                cat $file/echo1_${file}${z}_$ta | head -n 1 >> result_$ta
                cat $file/echo1_${file}${z}_$ta | tail -n 1 >> result_$ta
                echo "" >> result_$ta
                echo "" >> result_$ta
                echo "" >> result_$ta
            done
        done
    done
#done

cp result_sent result_sent.csv
cp result_recv result_recv.csv

