#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/bacnet_ip -m \
'{
  "client": "xrt bacnet-ip example",
  "request_id": "1021",
  "op": "device:delete_batch",
  "type": "xrt.request:1.0",
  "devices": [
    "bacnet-ip-sim-device-01",
    "bacnet-ip-sim-device-02",
    "bacnet-ip-sim-device-03"
  ]
}'
