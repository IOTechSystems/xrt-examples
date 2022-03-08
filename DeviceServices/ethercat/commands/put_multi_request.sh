#!/bin/sh
mosquitto_pub -t xrt/devices/ethercat/request -m \
'{
  "client": "example",
  "request_id": "1030",
  "op": "device:put",
  "device": "EL7037",
  "values": {
    "Enable micro increments": false,
    "Reversion of rotation": true
  }
}'
