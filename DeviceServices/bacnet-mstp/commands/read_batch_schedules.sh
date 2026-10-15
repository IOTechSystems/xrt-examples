#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/bacnet_mstp -m \
'{
  "client": "xrt bacnet-mstp example",
  "request_id": "1032",
  "op": "schedule:read_batch",
  "type": "xrt.request:1.0",
  "schedules": [
    "bacnet-mstp-schedule1",
    "bacnet-mstp-schedule2",
    "bacnet-mstp-schedule3"
  ]
}'
