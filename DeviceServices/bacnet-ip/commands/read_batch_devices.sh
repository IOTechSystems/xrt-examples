#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/bacnet_ip -m \
'{
  "client": "xrt bacnet-ip example",
  "request_id": "1022",
  "op": "device:read_batch",
  "type": "xrt.request:1.0",
  "devices": [
    "bacnet-ip-sim-01",
    "bacnet-ip-sim-02",
    "bacnet-ip-sim-03"
  ]
}'
