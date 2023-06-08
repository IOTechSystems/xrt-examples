#!/bin/sh

mosquitto_pub -t xrt/devices/file/request -m \
'{
  "client": "example",
  "request_id": "1092",
  "op": "device:update",
  "type": "xrt.request:1.0",
  "device": "file-example",
  "device_info":  {
    "operational": false
  }
}'
