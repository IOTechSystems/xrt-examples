#!/bin/sh

mosquitto_pub -t xrt/devices/gps/request -m \
'{
  "client": "example",
  "request_id": "1092",
  "op": "device:update",
  "type": "xrt.request:1.0",
  "device": "gps-sim",
  "device_info":  {
    "operational": true
  }
}'
