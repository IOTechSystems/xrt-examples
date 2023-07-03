#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/modbus-tcp -m \
'{
  "client": "example",
  "request_id":"1012",
  "op": "profile:delete",
  "type": "xrt.request:1.0",
  "profile": "modbus-sim-profile"
}'
