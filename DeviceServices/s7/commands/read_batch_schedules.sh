#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/s7 -m \
'{
  "client": "example",
  "request_id": "1032",
  "op": "schedule:read_batch",
  "type": "xrt.request:1.0",
  "schedules": [
    "s7-sim-schedule1",
    "s7-sim-schedule2",
    "s7-sim-schedule3"
  ]
}'
