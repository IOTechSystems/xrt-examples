#!/bin/sh

mosquitto_pub -t spBv1.0/iotech/REQUEST/xrt/s7 -m \
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
