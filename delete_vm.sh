#!/bin/sh

set -e

#gcloud compute machine-types list
MACHINE_TYPE="n1-standard-2"
ZONE="europe-west1-b"

if [ $# -eq 0 ]; then
  echo "usage: $0 INSTANCE_NAME [ZONE]"
  exit 1
fi

INSTANCE_NAME="$1"

if [ $# -gt 1 ]; then
  ZONE=$2
fi

echo "Deleting $INSTANCE_NAME in zone $ZONE"

gcloud compute instances delete $INSTANCE_NAME --zone $ZONE
