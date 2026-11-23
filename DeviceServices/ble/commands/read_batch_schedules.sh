#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/ble -m \
'{
  "client": "xrt ble example",
  "request_id": "1032",
  "op": "schedule:read_batch",
  "type": "xrt.request:1.0",
  "schedules": [
    "ble-sim-schedule1",
    "ble-sim-schedule2",
    "ble-sim-schedule3"
  ]
}'
