#!/bin/sh

mosquitto_pub -t xrt/devices/profinet/request -m \
'{
  "client": "example",
  "request_id": "1092",
  "op": "device:update",
  "type": "xrt.request:1.0",
  "device": "netHAT",
  "device_info":  {
    "operational": false
  }
}'
