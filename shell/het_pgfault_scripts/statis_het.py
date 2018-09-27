#! /usr/bin/env python
# -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Copyright © 2018 jackchuang <jackchuang@mir>
#
# Distributed under terms of the MIT license.

import sys, os, pprint, time
import subprocess
"""
{
'<ins>': {'R':0, 'W': 0}
}
Dic[ins_ptr][op] = 
"""
APP_SOURCE_CODE=sys.argv[2]
APP_SOURCE_CODE_ARM=sys.argv[3]
TRACE=sys.argv[1]
INS_CENSUS_FILE = ['%s_ins_census.py' % TRACE,
                    '%s_ins_census_arm.py' % TRACE]
PGFAULT_CENSUS_FILE = ['%s_pgfault_census.py' % TRACE,
                        '%s_pgfault_census_arm.py' % TRACE]
#PREFETCH_CENSUS_FILE = ['%s_prefetch_census.py' % TRACE,
#                           '%s_prefetch_census_arm.py' % TRACE]

def my_func(test = "123"):
    print("I m test " + test)
    return 1

def check_params():
    #TODO
    return 1


print('-----------------------------------------------------')
print('USAGE: ./ <TRACE> <X86_SOURCE_CODE> <ARM_SOURCE_CODE>')
print('-----------------------------------------------------')
check_params

###########################################
# general faults for ploting (remote faults + pf pages)
###########################################
# extracting remote pg faults
print('extracting data by node and op...')
ops = ['R', 'W']
for node in range(0, 2): # server 0 ~ 4 # e.g. range(0,4) = [0,1,2,3]
    for op in ['R', 'W']:
        t_offset = 0
        ff = open('%s-%d-%s' % (TRACE, node, op), 'w')
        with open(TRACE) as f:
            for l in f.xreadlines():
                e = l.strip().split()
                if len(e) < 2: continue;
                if e[0][0] == "#": continue;
                e = l.split()
                del e[:3]
                time_ = float(e[0][:-1])
                if t_offset == 0: t_offset = time_;
                if e[2] != str(node): continue
                if e[1][:-1] == "pgfault":
                    if e[4] == op:
                        ff.write('%.6f %s %d\n' % (time_ - t_offset, e[2], int(e[6][:-3], 16)))
            #end line
        # end file
    #end R/W file
#end 0-3 file

# extracing pf pages
#os.system('./analyze_jack_pf.py %s' % TRACE)

###########################################
# ins
###########################################
print('extracting ins data...')
t_ofs = 0;
dict_ins_ptr = {}; # dictionary
with open(TRACE) as f:
    for i in range(0, 2): #todo remove 2
        for l in f.xreadlines():
            e = l.strip().split()
            if len(e) < 2: continue;
            if e[0][0] == "#": continue;
            del e[:3]
            if t_ofs == 0: t_ofs = float(e[0][:-1]);
            
            # we are interested in:
            if e[1][:-1] == "pgfault":
                if e[2] == str(i):
                    ins_ptr = e[5]
                    op = e[4]

#                   dict_ins_ptr.setdefault('%d ' + ins_ptr + ' ' + op % (int(ins_ptr[:-3], 16)), 0)
                    dict_ins_ptr.setdefault('%d %s %s' % (int(ins_ptr[:-3], 16), ins_ptr, op), 0)
                    dict_ins_ptr['%d %s %s' % (int(ins_ptr[:-3], 16), ins_ptr, op)] += 1

        #print dict_ins_ptr
        print('Writing to %s...' % (INS_CENSUS_FILE[i]))
        ff = open('%s' % (INS_CENSUS_FILE[i]), 'w')
        ff.write('AllData=' + pprint.pformat(dict_ins_ptr))
    #end nodes
#end ins

###########################################
# pgfault 
###########################################
print('extracting pgfault data...')
t_ofs = 0;
dict_pgfault = {}; # dictionary
with open(TRACE) as f:
    for i in range(0, 2): #todo remove 2
        for l in f.xreadlines():
            e = l.strip().split()
            if len(e) < 2: continue;
            if e[0][0] == "#": continue;
            del e[:3]
            if t_ofs == 0: t_ofs = float(e[0][:-1]);

            # we are interested in:
            if e[1][:-1] == "pgfault":
                if e[2] == str(i):
                    pgfault = e[6]
                    op = e[4]

                    dict_pgfault.setdefault('%d %s %s' % (int(pgfault[:-3], 16), pgfault, op), 0)
                    dict_pgfault['%d %s %s' % (int(pgfault[:-3], 16), pgfault, op)] += 1
        # end for
        print('Writing to %s...' % (PGFAULT_CENSUS_FILE[i]))
        ff = open('%s' % (PGFAULT_CENSUS_FILE[i]), 'w')
        ff.write('AllData=' + pprint.pformat(dict_pgfault))
    #end nodes
#end pgfault

###########################################
#prefetch
###########################################
#print('extracting prefetch data...')
#t_ofs = 0;
#dict_pf = {}; # dictionary
#with open(TRACE) as f:
#    for l in f.xreadlines():
#        e = l.strip().split()
#        if len(e) < 2: continue;
#        if e[0][0] == "#": continue;
#        del e[:3]
#        if t_ofs == 0: t_ofs = float(e[0][:-1]);
#        
#        # we are interested in:
#        # e = ['4946.752354:', 'prefetch:', '1', '7ffff355b000']
#        if e[1][:-1] == "prefetch":
#            pf_addr = e[3]
#            #op = e[4]
#
#            dict_pf.setdefault('%d %s' % (int(pf_addr[:-3], 16), pf_addr), 0)
#            dict_pf['%d %s' % (int(pf_addr[:-3], 16), pf_addr)] += 1
#    #end for
#    #print('Writing to %s...' % PREFETCH_CENSUS_FILE)
#    #ff = open('%s' % PREFETCH_CENSUS_FILE, 'w')
#    #ff.write('AllData=' + pprint.pformat(dict_pf))
##end pf

print('statis all done...')

# next process
#print('invoke ins_ptr_process.py...')
#os.system('./ins_ptr_process.py %s %s' % (INS_CENSUS_FILE[0], APP_SOURCE_CODE))
#os.system('./ins_ptr_process.py %s %s' % (INS_CENSUS_FILE[1], APP_SOURCE_CODE_ARM))
#print('invoke pgfault_process.py...')
#os.system('./pgfault_process.py %s %s' % (PGFAULT_CENSUS_FILE[0], APP_SOURCE_CODE))
#os.system('./pgfault_process.py %s %s' % (PGFAULT_CENSUS_FILE[1], APP_SOURCE_CODE_ARM))
#print('invoke prefetch_process.py...')
#os.system('./prefetch_process.py %s %s' % (PREFETCH_CENSUS_FILE, APP_SOURCE_CODE))

# auto re-get the results
ff = open('%s_result.sh' % TRACE, 'w')
ff.write('#! /bin/bash\n')
ff.write('./ins_ptr_process.py %s %s\n' % (INS_CENSUS_FILE[0], APP_SOURCE_CODE))
ff.write('./ins_ptr_process.py %s %s\n' % (INS_CENSUS_FILE[1], APP_SOURCE_CODE_ARM))
ff.write('./pgfault_process.py %s %s\n' % (PGFAULT_CENSUS_FILE[0], APP_SOURCE_CODE))
ff.write('./pgfault_process.py %s %s\n' % (PGFAULT_CENSUS_FILE[1], APP_SOURCE_CODE_ARM))

#USER=`whoami`
#USER = os.system('whoami')
USER = subprocess.check_output(['whoami'])
USER_TRIM = USER.replace('\n','')
print('sudo bash -c \"chown %s:%s %s_result.sh\"' % (USER_TRIM, USER_TRIM, TRACE))
sys.stdout.flush()
os.system('sudo bash -c \"chown %s:%s %s_result.sh\"' % (USER_TRIM, USER_TRIM, TRACE))
os.system('sudo bash -c \"chmod 775 %s_result.sh\"' % TRACE)
sys.stdout.flush()
sys.stdin.flush()
time.sleep(1)

# auto run the re-gen results
print('run ./%s_result.sh' % TRACE)
os.system('./%s_result.sh' % TRACE)
print('confliction with *_aarch64 src code')
