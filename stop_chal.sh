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

gcloud compute ssh $INSTANCE_NAME --command "sudo sh -c \"docker kill $CHAL_NAME; docker rm $CHAL_NAME\"" --zone $ZONE
gcloud compute instances remove-tags $INSTANCE_NAME --tags $CHAL_NAME --zone $ZONE
gcloud compute instances remove-labels $INSTANCE_NAME --labels=$CHAL_NAME --zone $ZONE
