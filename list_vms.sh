#!/bin/sh

set -e

#gcloud compute instances list --filter 'NAME : ctf-*' | tail -n+2 | awk '{print $1}'
gcloud compute instances list
