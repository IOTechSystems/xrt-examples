#!/bin/sh
mosquitto_pub -t xrt/devices/ble/request -m \
'{
  "client": "example",
  "request_id": "1030",
  "op": "device:put",
  "type": "xrt.request:1.0",
  "device": "ble-sim",
  "values": {
    "Static": 43,
    "Random": 0
  },
}'
