#!/bin/sh
mosquitto_pub -t xrt/device/ethernet_ip_device_service/request -m \
'{
  "client": "example",
  "request_id": "1030",
  "op": "device:put",
  "device": "ethernetip-sim",
  "values": {
    "DI1": false,
    "DI2": true,
    "DI3": true,
    "DI4": true
  }
}'
