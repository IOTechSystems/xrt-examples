#!/bin/sh

mosquitto_pub -t spBv1.0/iotech/REQUEST/xrt/gps -m \
'{
  "client": "example",
  "request_id": "1093",
  "op": "device:update",
  "type": "xrt.request:1.0",
  "device": "gps-sim",
  "device_info":  {
    "operational": true
  }
}'
