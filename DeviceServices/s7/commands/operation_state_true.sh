#!/bin/sh

mosquitto_pub -t xrt/devices/s7/request -m \
'{
  "client": "example",
  "request_id": "1093",
  "op": "device:update",
  "type": "xrt.request:1.0",
  "device": "s7-sim",
  "device_info":  {
    "operational": true
  }
}'
