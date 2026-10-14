#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/virtual -m \
'{
  "client":"example",
  "request_id": "1031",
  "op": "schedule:delete_batch",
  "type": "xrt.request:1.0",
  "schedules": [
    "virtual-schedule1",
    "virtual-schedule2",
    "virtual-schedule3"
  ]
}'
