#!/bin/sh

mosquitto_pub -t xrt/devices/ethercat/request -m \
'{
  "client": "example",
  "request_id": "1030",
  "op": "device:put",
  "type": "xrt.request:1.0",
  "device": "EL7037",
  "values": {
    "Enable - STM Control - PDO": true
  }
}'
