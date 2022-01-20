#!/bin/sh

mosquitto_pub -t xrt/devices/virtual/request -m \
'{
  "client": "example",
  "request_id": "1031",
  "op": "device:put",
  "device": "Random-Device",
  "values": {
    "Float32Value": 1.71
  }
}'
