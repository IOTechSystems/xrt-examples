#!/bin/sh

mosquitto_pub -t spBv1.0/iotech/REQUEST/xrt/modbus-tcp -m \
'{
  "client": "example",
  "request_id": "1092",
  "op": "device:update",
  "type": "xrt.request:1.0",
  "device": "modbus-sim",
  "device_info":  {
    "operational": false
  }
}'
