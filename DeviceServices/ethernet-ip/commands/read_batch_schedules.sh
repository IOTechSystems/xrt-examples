#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/ethernet_ip -m \
'{
  "client": "example",
  "request_id": "1032",
  "op": "schedule:read_batch",
  "type": "xrt.request:1.0",
  "schedules": [
    "ethernetip-sim-batch-sched1",
    "ethernetip-sim-batch-sched2",
    "ethernetip-sim-batch-sched3"
  ]
}'
