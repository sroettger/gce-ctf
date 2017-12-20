#!/bin/bash

set -e

PORT=1337

CHAL_NAME=$1
export CHAL_NAME

if [ $# -eq 0 ]; then
  echo 'need the challenge name as arg1'
  exit 1
fi

if [ $# -ge 2 ]; then
  PORT=$2
fi

MEMLIMIT=500000000
if [ $# -ge 3 ]; then
  MEMLIMIT=$3
fi

CPUSHARES=128
if [ $# -ge 4 ]; then
  CPUSHARES=$4
fi

MAXPIDS=256
if [ $# -ge 5 ]; then
  MAXPIDS=$5
fi

for i in {1..16}; do
  cgcreate -t user -g "cpu,memory,pids:$CHAL_NAME/$i"
  echo $MEMLIMIT > /sys/fs/cgroup/memory/$CHAL_NAME/$i/memory.limit_in_bytes
  echo $CPUSHARES > /sys/fs/cgroup/cpu/$CHAL_NAME/$i/cpu.shares
  echo $MAXPIDS > /sys/fs/cgroup/pids/$CHAL_NAME/$i/pids.max
done

exec /usr/bin/socat TCP-LISTEN:$PORT,fork,reuseaddr EXEC:/usr/bin/nsjail_wrap.sh,su=user,stderr
