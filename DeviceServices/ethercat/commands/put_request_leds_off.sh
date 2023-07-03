#!/bin/sh
mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/ethercat -m \
'{
  "client": "example",
  "request_id": "1030",
  "op": "device:put",
  "type": "xrt.request:1.0",
  "device": "XMC4800",
  "values": {
    "OUT_GEN_BIT1": false,
    "OUT_GEN_BIT2": false,
    "OUT_GEN_BIT3": false,
    "OUT_GEN_BIT4": false,
    "OUT_GEN_BIT5": false,
    "OUT_GEN_BIT6": false,
    "OUT_GEN_BIT7": false,
    "OUT_GEN_BIT8": false
  }
}'
