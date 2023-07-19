#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/ethercat -m \
'{
  "client": "example",
  "request_id": "1021",
  "op": "device:get",
  "type": "xrt.request:1.0",
  "device": "XMC4800",
  "resource": ["IN_GEN_BIT1", "IN_GEN_BIT2"]
}'
