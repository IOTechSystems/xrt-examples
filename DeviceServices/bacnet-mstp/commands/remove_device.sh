#!/bin/sh

mosquitto_pub -t xrt/devices/bacnet_mstp/request -m \
'{
  "client": "example",
  "request_id": "1011",
  "op": "device:delete",
  "type": "xrt.request:1.0",
  "device": "bacnet-mstp-sim"
}'
