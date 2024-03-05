#!/bin/sh

mosquitto_pub -t xrt/devices/canbus/request -m \
'{
  "client": "example",
  "request_id": "1092",
  "op": "device:update",
  "type": "xrt.request:1.0",
  "device": "canbus-example",
  "device_info":  {
    "operational": false
  }
}'
