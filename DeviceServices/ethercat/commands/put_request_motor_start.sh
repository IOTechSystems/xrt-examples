#!/bin/sh

mosquitto_pub -t spBv1.0/iotech/REQUEST/xrt/ethercat -m \
'{
  "client": "example",
  "request_id": "1030",
  "op": "device:put",
  "type": "xrt.request:1.0",
  "device": "EL7037",
  "values": {
    "Velocity - STM Velocity - PDO": 8000
  }
}'
