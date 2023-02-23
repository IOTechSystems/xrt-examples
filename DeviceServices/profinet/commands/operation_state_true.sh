#!/bin/sh

mosquitto_pub -t xrt/devices/profinet/request -m \
'{
  "client": "example",
  "request_id": "1093",
  "op": "device:update",
  "type": "xrt.request:1.0",
  "device": "netHAT",
  "device_info":  {
    "operational": true
  }
}'
