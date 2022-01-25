#!/bin/sh

mosquitto_pub -t xrt/devices/ble/request -m \
'{
  "client": "example",
  "request_id": "1030",
  "op": "device:put",
  "device": "ble-sim",
  "values": {
    "Static": 64,
  },
}'
