#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/bacnet_mstp -m \
'{
  "client":"example",
  "request_id": "1060",
  "op": "discovery:trigger",
  "type": "xrt.request:1.0"
}'
