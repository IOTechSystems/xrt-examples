#!/bin/sh

mosquitto_pub -t spBv1.0/iotech/REQUEST/xrt/ethernet_ip -m \
'{
  "client": "example",
  "request_id": "1030",
  "op": "device:put",
  "type": "xrt.request:1.0",
  "device": "ethernetip-sim",
  "values": {
    "DI1": true
  }
}'
