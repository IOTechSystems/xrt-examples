#!/bin/sh
mosquitto_pub -t xrt/devices/ethercat/request -m \
'{
  "client": "example",
  "request_id": "1030",
  "op": "device:put",
  "device": "XMC4800",
  "values": {
    "OUT_GEN_BIT1": true,
    "OUT_GEN_BIT3": true,
    "OUT_GEN_BIT5": true,
    "OUT_GEN_BIT7": true
  },
}'
