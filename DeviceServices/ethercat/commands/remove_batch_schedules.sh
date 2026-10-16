#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/ethercat -m \
'{
  "client": "example",
  "request_id": "1031",
  "op": "schedule:delete_batch",
  "type": "xrt.request:1.0",
  "schedules": [
    "ethercat-schedule1",
    "ethercat-schedule2",
    "ethercat-schedule3"
  ]
}'
