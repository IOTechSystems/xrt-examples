#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/ethernet_ip -m \
'{
  "client": "example",
  "request_id": "1022",
  "op": "device:read_batch",
  "type": "xrt.request:1.0",
  "devices": [
    "ethernetip-sim-01",
    "ethernetip-sim-02",
    "ethernetip-sim-03"
  ]
}'
