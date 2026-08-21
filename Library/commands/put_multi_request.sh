#!/bin/sh

mosquitto_pub -t xrt/devices/virtual/request -m \
'{
  "client": "example",
  "request_id": "1030",
  "op": "device:put",
  "type": "xrt.request:1.0",
  "device": "Virtual-Device",
  "values": {
    "StoreInt32Value": 26,
    "StoreFloat32Value": 3.14
  }
}'
