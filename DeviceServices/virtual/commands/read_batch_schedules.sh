#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/virtual -m \
'{
  "client": "xrt virtual example",
  "request_id": "1032",
  "op": "schedule:read_batch",
  "type": "xrt.request:1.0",
  "schedules": [
    "virtual-schedule1",
    "virtual-schedule2",
    "virtual-schedule3"
  ]
}'
