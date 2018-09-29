#! /usr/bin/env python
## -*- coding: utf-8 -*-
# vim:fenc=utf-8
#
# Copyright © 2018 jackchuang <jackchuang@mir6>
#
# Distributed under terms of the MIT license.

"""
Dict[ins_ptr][op] =
Dict = {}; # dictionary
"""
import sys, os, pprint, time, subprocess

DEBUG = False
#DEBUG = True
EXPECT_ARGS = 3 # MANUAL, including ./<THIS>

MAX_X86_THREAD = 16
MAX_ARM_THREAD = 96

APP_SOURCE_CODE=""
APP_SOURCE_CODE_ARM=""
TRACE=""
TRACE_FOX=""

INS_CENSUS_FILE = []
PGFAULT_CENSUS_FILE = []

threads = [] # list of struct_thread objs
threads_fox = [] # list of struct_thread objs

class struct_thread(object):
    # class variable shared by all instances
    def __init__(self):
        # instance variable unique to each instance
        # representative for all regions
        self.pid = 0
        self.curr_region_id = 0
        self.regions = []
        # temporary marks per region
        self.inside_region = False
        self.begin = False
        self.end = True
        self.conflictions = 0
        self.fence_cnt = 0
        self.begin_cnt = 0
        self.end_cnt = 0
        #self.hit_first_begin = False

def dbg(s):
    if DEBUG:
        print(s)

def usage():
    print('-----------------------------------------------------')
    print('USAGE: ./ <TRACE> <TRACE_FOX>')
    print('-----------------------------------------------------')
    return 0

def check_params():
    global TRACE
    global TRACE_FOX
    dbg("check args current %d" % (len(sys.argv)))
    if len(sys.argv) < EXPECT_ARGS:
        print("WRONG args, only %d, need %d" % (len(sys.argv), EXPECT_ARGS))
        sys.exit(usage())
    else:
        dbg("good args")

    #APP_SOURCE_CODE_ARM=sys.argv[3]
    TRACE=sys.argv[1]
    TRACE_FOX=sys.argv[2]
    dbg(TRACE)

    INS_CENSUS_FILE.append('%s_ins_census.py' % TRACE)
    INS_CENSUS_FILE.append('%s_ins_census_arm.py' % TRACE)
    PGFAULT_CENSUS_FILE.append('%s_pgfault_census.py' % TRACE)
    PGFAULT_CENSUS_FILE.append('%s_pgfault_census_arm.py' % TRACE)
    dbg("INS_CENSUS_FILE len %d" % len(INS_CENSUS_FILE))
    dbg("PGFAULT_CENSUS_FILE len %d" % len(PGFAULT_CENSUS_FILE))
#    INS_CENSUS_FILE = ['%s_ins_census.py' % TRACE,
#                        '%s_ins_census_arm.py' % TRACE]
#    PGFAULT_CENSUS_FILE = ['%s_pgfault_census.py' % TRACE,
#                          '%s_pgfault_census_arm.py' % TRACE]
    return 0

def my_dbg():
    dbg('%s %s' % (INS_CENSUS_FILE[0], INS_CENSUS_FILE[1]))
    dbg('%s %s' % (PGFAULT_CENSUS_FILE[0], PGFAULT_CENSUS_FILE[1]))
    return 0


def create_per_thread_obj(thread_cnt):
    dbg(range(thread_cnt))
    for i in range(thread_cnt):
        threads.append(struct_thread()) # i will be replaced with  pid
    dbg('%d' % len(threads))
    for t in threads:
        dbg('t pid %d' % t.pid)
        dbg('t curr_region_id %d' % t.curr_region_id)
        dbg('t inside_region %r' % t.inside_region)
        dbg('t regions = []')
        dbg('t begin %r' % t.begin)
        dbg('t end %r' % t.end)

def find_pid_in_pids(pid):
    found = False
    for t in threads:
        #print ('check t.pid %d pid %d' % (t.pid, pid))
        if (t.pid == pid):
            found = True
            break;
    return found

def discover_pids(raw, thread_cnt):
    found_pids = 0
    for r in raw:
        e = r.strip().split()

        if len(e) < 2: continue;
        if e[0][0] == "#": continue;
        e = r.split()
        if (e[4][:-1] == "tso"): # can narrow down to 'b' #if (e[8] == 'b'):
            pid = int(e[6])
            if (find_pid_in_pids(pid) == False):
                t = threads[found_pids]
                #print(pid)
                t.pid = pid
                found_pids += 1
            else:
                dbg('found a duplicated pid')
            
        if (found_pids >= thread_cnt):
            break;

    if (found_pids >= thread_cnt):
        dbg('found all pids')
    else:
        dbg('cannot find all pids')
        sys.exit()
    i = 0
    for t in threads:
        dbg('[%d] pid %d' % (i, t.pid))
        i += 1

# input string
def pid_to_thread(pid):
    for t in threads:
        if (t.pid == int(pid)):
            return t
    return None

def dump_thread_info(t):
    print('[%d] len(regions) %d curr_region_id %d --- '
               'begin_cnt %d end_cnt %d fence_cnt %d conflictions %d --- '
                'in_region %r b %r e %r ' %
                (t.pid, len(t.regions), t.curr_region_id,
                        t.begin_cnt, t.end_cnt,
                        t.fence_cnt, t.conflictions,
                        t.inside_region, t.begin, t.end))

def tso_begin(t):
    if (t.begin == True or t.end == False or t.inside_region == True):
        print('begin status check: fail')
        dump_thread_info(t)
        sys.exit()
    t.begin = True
    t.end = False
    t.inside_region = True
    t.regions.append(set())
    #print('[%d] current region id %d' % (t.pid, len(t.regions)))

def tso_end(t):
    if (t.begin == False or t.end == True or t.inside_region == False):
        print('end status check: fail')
        dump_thread_info(t)
        sys.exit()
    t.begin = False
    t.end = True
    t.inside_region = False
    t.curr_region_id += 1 # shift to next slot

def tso_fence(t):
    tso_end(t)
    tso_begin(t)
    return

def main1(trace, node, thread_cnt, threads):
    global threads
    threads = []

    # create a list of struct_thread objects
    create_per_thread_obj(thread_cnt)
    print('extracting tso regions - constructing per thread data..')
    #ff = open('%s-%d-%s' % (trace, node, op), 'w') # open a output file
    dbg('opening %s' % trace)
    with open(trace) as f:
        raw = f.readlines()
        dbg('line = %d' % len(raw))
        discover_pids(raw, thread_cnt)
        # list comprehension [out expression + input seq + optional preficate]
        #raw = [r.strip() for r in raw]
        for r in raw:
            e = r.strip().split()           # remove spaces + to array
            if len(e) < 2: continue;
            if e[0][0] == "#": continue;
            e = r.split()                   # to array

            ###########
            # main job
            ###########

            # "" tso ""
            # [5]: 0 2911 115 f - [5]: nid [6]: pid [7]: tso_id [8]: action
            if (e[4][:-1] == "tso"):
                # get thread object according to pid
                t = pid_to_thread(e[6])
                if (t == None):
                    print("Cannot find PID %d" % int(e[6]))
                    sys.exit()

                # no need to record current cnt
                if (e[8] == 'b'):
                    t.begin_cnt += 1
                    tso_begin(t)
                elif (e[8] == 'e'):
                    t.end_cnt += 1
                    tso_end(t)
                elif (e[8] == 'f'):
                    # only deal with 'f' whthin regions
                    if (t.inside_region == True):
                        t.fence_cnt += 1
                        tso_fence(t)
                continue;
            
            # "" pgfault ""
            # [5]: 1 2986 R 502888 7fffb6e49000 1024
            elif (e[4][:-1] == "pgfault"):
                if int(e[5]) != node: continue;
                if e[7] != 'W': continue;
                t = pid_to_thread(e[6])
                if (t == None):
                    #print("redundant PID %d" % int(e[6]))
                    continue;
                if (t.inside_region != True): continue;
                addr = e[9]
                #dump_thread_info(t)
                if addr in t.regions[t.curr_region_id]:
                    #print('conflict in its own region............')
                    t.conflictions += 1
                else:
                    t.regions[t.curr_region_id].add(addr)
            # line end
        # raw end aka file end
        i = 0
        for t in threads:
            print('%d/' % i, end = '')
            dump_thread_info(t)
            i += 1
            # end also include a fence

            #should not in a region
            #print('t inside_region %r' % t.inside_region)
            
            # sanity check
            #print('t begin %r' % t.begin)
            #print('t end %r' % t.end)
        #
        print('done extracting trace file %s' % trace)


        print('find collisions between %s' % trace)
    # close file
#end func

"""
Precheck()
"""
#usage()
check_params()
my_dbg()

"""
Main()
"""
dbg(TRACE)
node = 0
main1(TRACE, node, MAX_X86_THREAD, threads)
node = 1
main1(TRACE_FOX, node, MAX_ARM_THREAD, threads_fox)

print('Done')
