#!/bin/bash

if [ -z $CHAL_NAME ]; then
  echo "$$CHAL_NAME is 0 - can't start"
  exit 1
fi

if [ -z $RLIMIT_AS ]; then
  RLIMIT_AS=max
fi
if [ -z $RLIMIT_CORE ]; then
  RLIMIT_CORE=max
fi
if [ -z $RLIMIT_CPU ]; then
  RLIMIT_CPU=max
fi
if [ -z $RLIMIT_FSIZE ]; then
  RLIMIT_FSIZE=max
fi
if [ -z $RLIMIT_NOFILE ]; then
  RLIMIT_NOFILE=max
fi
if [ -z $RLIMIT_NPROC ]; then
  RLIMIT_NPROC=max
fi
if [ -z $RLIMIT_STACK ]; then
  RLIMIT_STACK=max
fi

CGID="$(( ( RANDOM % 16 )  + 1 ))"

exec cgexec -g "cpu,memory,pids:$CHAL_NAME/$CGID" /usr/bin/nsjail -Mo -l /dev/zero \
  --rlimit_as $RLIMIT_AS \
  --rlimit_core $RLIMIT_CORE \
  --rlimit_cpu $RLIMIT_CPU \
  --rlimit_fsize $RLIMIT_FSIZE \
  --rlimit_nofile $RLIMIT_NOFILE \
  --rlimit_nproc $RLIMIT_NPROC \
  --rlimit_stack $RLIMIT_STACK \
  --disable_clone_newnet \
  --disable_no_new_privs \
  --time_limit 30 \
  --tmpfsmount /tmp \
  --tmpfs_size 20971520 \
  -U 1337:427680:1 \
  -U 0:1337:1 \
  -U 427680:427681:65535 \
  -G 1337:427680:1 \
  -G 0:1337:1 \
  -G 427680:427681:65535 \
  -R /bin \
  -R /dev \
  -R /etc \
  -R /home \
  -R /lib \
  -R /lib64 \
  -R /usr \
  -R /usr/bin/newuidmap_user:/usr/bin/newuidmap \
  -- /home/user/chal
