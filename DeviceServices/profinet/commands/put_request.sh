#!/bin/sh

mosquitto_pub -t xrt/devices/profinet/request -m \
'{
  "client": "example",
  "request_id": "1030",
  "op": "device:put",
  "type": "xrt.request:1.0",
  "device": "netHAT",
  "values": {
    "OutputFloat32": -27.8
  }
}'
