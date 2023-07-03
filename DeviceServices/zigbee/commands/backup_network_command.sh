#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/zigbee -m \
'{
  "client": "example",
  "request_id": "1031",
  "op": "device:get",
  "type": "xrt.request:1.0",
  "device": "coordinator_device",
  "resource": "backup"
}'
