#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/ethernet_ip -m \
'{
  "client":"example",
  "request_id": "1040",
  "op": "schedule:add",
  "type": "xrt.request:1.0",
  "schedule": {
    "name":"ethernetip-sim-sched1",
    "device":"ethernetip-sim",
    "resource":"DO1",
    "interval": 1000000
  }
}'
