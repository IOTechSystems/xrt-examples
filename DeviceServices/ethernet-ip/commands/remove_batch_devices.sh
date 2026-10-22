#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/ethernet_ip -m \
'{
  "client": "example",
  "request_id": "1021",
  "op": "device:delete_batch",
  "type": "xrt.request:1.0",
  "devices": [
    "ethernetip-sim-device-01",
    "ethernetip-sim-device-02",
    "ethernetip-sim-device-03"
  ]
}'
