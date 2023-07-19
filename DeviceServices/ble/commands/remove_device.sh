#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/ble -m \
'{
  "client": "example",
  "request_id":"1011",
  "op": "device:delete",
  "type": "xrt.request:1.0",
  "device": "ble-sim"
}'
