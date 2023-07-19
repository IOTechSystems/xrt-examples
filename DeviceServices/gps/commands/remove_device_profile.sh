#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/gps -m \
'{
  "client": "example",
  "request_id": "1012",
  "op": "profile:delete",
  "type": "xrt.request:1.0",
  "profile": "GPS-Device"
}'
