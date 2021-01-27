#!/bin/sh

HUBNAME=$1
RESOURCE=$2
VALUE=$3
ID=`azsphere_v1 device list-attached | grep ID | cut -d' ' -f4 | tr '[A-Z]' '[a-z]'`

az iot hub invoke-device-method --hub-name ${HUBNAME} --device-id ${ID} --method-name publish  --method-payload "{\"device\":\"damocles-virt1\", \"values\": {\"${RESOURCE}\":${VALUE}}}"
