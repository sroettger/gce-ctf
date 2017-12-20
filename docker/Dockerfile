FROM ubuntu:17.04


RUN groupadd --gid 1337 user
RUN useradd --uid 1337 --gid 1337 -d /home/user --create-home --no-user-group -s /bin/false user
RUN apt-get update
RUN apt-get install -y socat
RUN apt-get install -y uidmap
RUN apt-get install -y cgroup-tools
RUN apt-get install -y libprotobuf10
RUN cp /usr/bin/newuidmap /usr/bin/newuidmap_user
RUN chown user:user /usr/bin/newuidmap_user
RUN chmod 04555 /usr/bin/newuidmap_user

COPY ./run_chal.sh /usr/sbin/run_chal.sh
COPY ./nsjail_wrap.sh /usr/bin/nsjail_wrap.sh
COPY ./nsjail/nsjail /usr/bin/nsjail
COPY ./subuid /etc/subuid
COPY ./subgid /etc/subgid
