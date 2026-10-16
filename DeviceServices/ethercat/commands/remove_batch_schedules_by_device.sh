#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/ethercat -m \
'{
  "client": "example",
  "request_id": "1035",
  "op": "schedule:delete_batch",
  "type": "xrt.request:1.0",
  "device": "XMC4800"
}'
