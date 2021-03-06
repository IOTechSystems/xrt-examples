#!/bin/sh

HUBNAME=$1
DEVICENAME=$2
RESOURCE=$3
VALUE=$4
ID=`azsphere device list-attached | grep ID | cut -d' ' -f4 | tr '[A-Z]' '[a-z]'`

az iot hub invoke-device-method --hub-name ${HUBNAME} --device-id ${ID} --method-name publish  --method-payload "{\"device\":\"${DEVICENAME}\", \"values\": {\"${RESOURCE}\":${VALUE}}}"
