#!/bin/sh

mosquitto_pub -t xrt/devices/modbus/request -m \
'{
  "client": "example",
  "request_id": "1030",
  "op": "device:put",
  "device": "modbus-sim",
  "values": {
    "Current": 30,
  },
}'
