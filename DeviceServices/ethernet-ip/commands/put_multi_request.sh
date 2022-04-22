#!/bin/sh

mosquitto_pub -t xrt/devices/ethernet_ip/request -m \
'{
  "client": "example",
  "request_id": "1030",
  "op": "device:put",
  "type": "xrt.request:1.0",
  "device": "ethernetip-sim",
  "values": {
    "DI1": false,
    "DI2": true,
    "DI3": true,
    "DI4": false
  }
}'
