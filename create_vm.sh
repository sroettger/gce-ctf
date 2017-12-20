#!/bin/sh

set -e

#gcloud compute machine-types list
MACHINE_TYPE="n1-standard-2"
ZONE="europe-west1-b"

if [ $# -eq 0 ]; then
  echo "usage: $0 INSTANCE_NAME [MACHINE_TYPE] [ZONE]"
  exit 1
fi

INSTANCE_NAME="$1"

if [ $# -gt 1 ]; then
  MACHINE_TYPE=$2
fi

if [ $# -gt 2 ]; then
  ZONE=$3
fi

echo "Creating $INSTANCE_NAME with machine type $MACHINE_TYPE"

gcloud compute instances create $INSTANCE_NAME --boot-disk-size 200GB --image-family coreos-stable --image-project coreos-cloud --machine-type $MACHINE_TYPE --metadata-from-file startup-script=vm_startup.sh --zone $ZONE --no-service-account --no-scopes
