#!/bin/bash

set -e


if [ ! $# -eq 1 ]; then
  echo "usage: $0 CHAL_NAME"
  exit 1
fi

CHAL_NAME=$1
if [ -z $CHAL_NAME ]; then
  echo "chal name is empty"
  exit 1
fi

gcloud compute instances list --filter="labels.$CHAL_NAME:*"
