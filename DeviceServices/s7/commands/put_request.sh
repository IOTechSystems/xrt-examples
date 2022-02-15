#!/bin/sh

mosquitto_pub -t xrt/devices/s7/request -m \
'{
  "client": "example",
  "request_id": "1030",
  "op": "device:put",
  "device": "s7-sim",
  "values": {
    "DB_1_I64": 42,
  },
}'
