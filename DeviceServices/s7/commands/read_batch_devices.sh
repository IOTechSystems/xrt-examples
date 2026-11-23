#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/s7 -m \
'{
  "client": "example",
  "request_id": "1022",
  "op": "device:read_batch",
  "type": "xrt.request:1.0",
  "devices": [
    "s7-sim-01",
    "s7-sim-02",
    "s7-sim-03"
  ]
}'
