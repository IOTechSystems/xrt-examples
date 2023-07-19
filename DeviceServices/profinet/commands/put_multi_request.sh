#!/bin/sh
mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/profinet -m \
'{
  "client": "example",
  "request_id": "1030",
  "op": "device:put",
  "type": "xrt.request:1.0",
  "device": "netHAT",
  "values": {
    "OutputUint8": 17,
    "OutputUint32-offset-20": 87500
  }
}'
