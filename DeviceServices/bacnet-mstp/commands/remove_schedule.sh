#!/bin/sh

mosquitto_pub -t spBv1.0/iotech/REQUEST/node0/bacnet_mstp -m \
'{
  "client": "example",
  "request_id": "1041",
  "op": "schedule:delete",
  "type": "xrt.request:1.0",
  "schedule": "bacnet-mstp-sim-schedule1"
}'
