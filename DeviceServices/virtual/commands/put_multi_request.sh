#!/bin/sh

mosquitto_pub -t xrt/devices/virtual/request -m \
'{
  "client": "example",
  "request_id": "1030",
  "op": "device:put",
  "device": "Random-Device",
  "values": {
    "Int32Value": 26,
    "Float32Value": 3.14
  }
}'
