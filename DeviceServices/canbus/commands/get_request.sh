#!/bin/sh

mosquitto_pub -t xrt/devices/canbus/request -m \
'{
  "client": "example",
  "request_id": "1020",
  "op": "device:get",
  "type": "xrt.request:1.0",
  "device": "canbus-string-example",
  "resource": "Raw-CAN"
}'
