#!/bin/bash

ANALYZE="/home/jackchuang/popcorn/popcorn-compiler/tool/page_access_trace/analyze"
LOG=""
BIN_ARM=""
BIN_X86=""

function print_help {
  echo "Usage: run-pat-analysis.sh -i LOG -a ARM_BIN -x X86_BIN"
}

while [[ $1 != "" ]]; do
  case $1 in
    -i | --input) LOG=$2; shift;;
    -a ) BIN_ARM=$2; shift;;
    -x ) BIN_X86=$2; shift;;
    *) echo "Unknown argument '$1'"; print_help; exit 1;;
  esac
  shift
done

if [[ ! -f $LOG ]]; then 
  echo "Trace file '$LOG' doesn't exist"
  print_help
  exit 1
fi

if [[ ! -f $BIN_ARM ]]; then
  echo "Binary '$BIN_ARM' doesn't exist"
  print_help
  exit 1
fi

if [[ ! -f $BIN_X86 ]]; then
  echo "Binary '$BIN_X86' doesn't exist"
  print_help
  exit 1
fi

NAME=`echo $LOG |sed 's/_trace.*//g'`
$ANALYZE -i $LOG -b $BIN_ARM --no-code -n 1 -d --num 30 -v > ${NAME}_data-node1.log &
$ANALYZE -i $LOG -b $BIN_X86 --no-code -n 0 -d --num 30 -v > ${NAME}_data-node0.log &
$ANALYZE -i $LOG -b $BIN_ARM --no-code -n 1 -l --num 30 -v > ${NAME}_locs-node1.log &
$ANALYZE -i $LOG -b $BIN_X86 --no-code -n 0 -l --num 30 -v > ${NAME}_locs-node0.log &
wait
