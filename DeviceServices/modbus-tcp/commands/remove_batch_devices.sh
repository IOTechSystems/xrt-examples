#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/modbus-tcp -m \
'{
  "client": "xrt modbus-tcp example",
  "request_id": "1021",
  "op": "device:delete_batch",
  "type": "xrt.request:1.0",
  "devices": [
    "modbus-sim-01",
    "modbus-sim-02",
    "modbus-sim-03"
  ]
}'
