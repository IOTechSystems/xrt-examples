#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/virtual -m \
'{
  "client": "xrt virtual example",
  "request_id": "1034",
  "op": "schedule:read_batch",
  "type": "xrt.request:1.0",
  "device": "Virtual-Device"
}'
