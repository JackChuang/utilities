#!/usr/bin/env python3
import argparse
import re
import glob
import sys
import tokenize
import csv

########## Begin
c_line=0
#ff = range(1, 10+1)
#ff = ["node4size64_data", "node4size256_data"]
#var1=None

var_1 = []
var = []
timeDiff_1 = []
timeDiff_2 = []
timeDiff_3 = []

filecnt=0

ff = None # currFileName
for file_tail in ["sent", "recv"]:
    ff = "result_" + file_tail
    print("open file: " + ff)
    for curr in [1]:
        try: 
            fin = open(str(ff), "r");
            fout = open(str(ff) + "_output" , "w");
            c_line = 0
            del var_1[:]
            for line in fin:
                c_line += 1;
                print(line)
                
                if (c_line == 2 || c_line == 3):
                    row = line.split(' ')
                    for tmp in row:
                        #print(tmp)
                        var[0] = tmp[0]
                        var[1] = tmp[1]
                        #int(tmp)
                #fi
                
                #var_1.append(float(line)) #t[0]
                
                if (c_line == 4): #line 4 8 12...
                    c_line = 0;
                    # calculate
                    # ..................
                    # write to file
                    fout.wrie(line);
                #if4
            #lines
            print("1 file done")
            #Do Math
            filecnt += 1
            #diff1 = var1 - 0	#
            
            #print('run '+ str(filecnt) +'\t\t1 '+str(diff1)+'\t2 '+str(diff2)+'\t3 '+str(diff3))
            #print('run '+ str(filecnt) +'\t\t1 '+str(diff1))
            
            #timeDiff_1.append(var1)

            #Do Avgerage avg for a file
            curAvg1=0
            for c in var_1:
                    curAvg1 += c
            Aa1 = curAvg1/c_line
            print('Average by ' + str(c_line) + '\t' + str(Aa1))

            #Now time to save to file!
            filename ='jack_total.csv'
            with open(filename,'a') as csvv:
                writer = csv.writer(csvv)
                writer.writerow(str(Aa1))
        
        except:
            print("fail")
            pass
                    #Add diff1 to end of array timeDiff_1
    #end for ff (a file)
#send/recv/ done
#print('\n\n')
