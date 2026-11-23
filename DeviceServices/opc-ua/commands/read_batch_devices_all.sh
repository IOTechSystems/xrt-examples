#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/opc_ua -m \
'{
  "client": "example",
  "request_id": "1023",
  "op": "device:read_batch",
  "type": "xrt.request:1.0",
  "pattern": ".*"
}'
