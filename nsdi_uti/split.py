#!/usr/bin/python

import sys

N = 0;
with open(sys.argv[1]) as f:
	f_sent = open(sys.argv[1] + "_sent", "w");
	f_recv = open(sys.argv[1] + "_recv", "w");
	for l in f.xreadlines():
		if (N % 2 == 0) :
			f_sent.write(l);
		else:
			f_recv.write(l);
		N += 1
