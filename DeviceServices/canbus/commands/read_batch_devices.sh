#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/canbus -m \
'{
  "client": "example",
  "request_id": "1022",
  "op": "device:read_batch",
  "type": "xrt.request:1.0",
  "devices": [
    "canbus-device-01",
    "canbus-device-02",
    "canbus-device-03"
  ]
}'
