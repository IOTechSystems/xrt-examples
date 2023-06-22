#!/bin/sh

mosquitto_pub -t spBv1.0/iotech/REQUEST/xrt/ethercat -m \
'{
  "client": "example",
  "request_id": "1093",
  "op": "device:update",
  "type": "xrt.request:1.0",
  "device": "EL7037",
  "device_info":  {
    "operational": true
  }
}'
