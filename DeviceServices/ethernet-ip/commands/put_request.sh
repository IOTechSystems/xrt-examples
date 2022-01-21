#!/bin/sh

mosquitto_pub -t xrt/device/ethernet_ip/request -m \
'{
  "client": "example",
  "request_id": "1030",
  "op": "device:put",
  "device": "ethernetip-sim",
  "values": {
    "DO1": true
  }
}'
