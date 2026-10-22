#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/bacnet_ip -m \
'{
  "client":"xrt bacnet-ip example",
  "request_id": "1031",
  "op": "schedule:delete_batch",
  "type": "xrt.request:1.0",
  "schedules": [
    "bacnet-ip-schedule1",
    "bacnet-ip-schedule2",
    "bacnet-ip-schedule3"
  ]
}'
