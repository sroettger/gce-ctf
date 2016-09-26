#!/bin/bash

set -e

if [ ! $# -eq 3 ]; then
  echo "usage: $0 ZONE INSTANCE_NAME CONFIG_FILE"
  exit 1
fi

ZONE=$1
if [ -z $ZONE ]; then
  ZONE="europe-west1-b"
fi

INSTANCE_NAME=$2
CONFIG_FILE=$3
source $CONFIG_FILE

if [ -z $CHAL_NAME ]; then
  echo "chal name is empty"
  exit 1
fi

echo '[*] killing existing containers and removing files'
gcloud compute ssh root@$INSTANCE_NAME --command "docker kill $CHAL_NAME; docker rm $CHAL_NAME; chattr -i /chals/$CHAL_NAME/*; rm -R /chals/$CHAL_NAME; mkdir -p /chals/$CHAL_NAME" --zone $ZONE
echo '[*] copying files'
gcloud compute copy-files $FLAG_FILE $CHAL_FILES root@$INSTANCE_NAME:/chals/$CHAL_NAME/ --zone $ZONE
if [ ! -z "$INSTALL_SCRIPT" ]; then
  echo '[*] running install script'
  gcloud compute ssh root@$INSTANCE_NAME --command "$INSTALL_SCRIPT" --zone $ZONE
else
  echo '[*] no install script - skipping'
fi
echo '[*] starting container'
gcloud compute ssh root@$INSTANCE_NAME --command "docker pull tsuro/nsjail-ctf && docker run -d --privileged --expose $PORT --publish $PORT:$PORT --name $CHAL_NAME --restart=always -v /chals/$CHAL_NAME:/home/user:ro tsuro/nsjail-ctf /usr/sbin/run_chal.sh $CHAL_NAME $PORT" --zone $ZONE
echo '[*] adding instance tag'
gcloud compute instances add-tags $INSTANCE_NAME --tags $CHAL_NAME --zone $ZONE
echo '[*] adding firewall rule'
FIREWALL_MSG=$(gcloud compute firewall-rules create $CHAL_NAME --allow tcp:$PORT --target-tags $CHAL_NAME 2>&1)
FIREWALL_RET=$?
if [ $FIREWALL_RET != 0 ]; then
  if [[ $FIREWALL_MSG == *"already exists"* ]]; then
    echo '[*] firewall rule already exists - skipping'
  else
    echo $FIREWALL_MSG
    exit 1
  fi
fi
