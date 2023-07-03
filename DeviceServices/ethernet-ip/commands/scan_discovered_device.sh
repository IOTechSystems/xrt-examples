#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/ethernet_ip -m \
'{
  "client":"example",
  "request_id": "1060",
  "op": "device:scan",
  "type": "xrt.request:1.0",
  "device": "ethernetip-sim"
}'
