#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/ethercat -m \
'{
  "client": "example",
  "request_id": "1021",
  "op": "device:delete_batch",
  "type": "xrt.request:1.0",
  "devices": [
    "EK1100",
    "EL7037",
    "XMC4800"
  ]
}'
