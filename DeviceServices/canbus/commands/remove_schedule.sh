#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/canbus -m \
'{
  "client":"example",
  "request_id": "1041",
  "op": "schedule:delete",
  "type": "xrt.request:1.0",
  "schedule": "canbus-example-schedule1"
}'
