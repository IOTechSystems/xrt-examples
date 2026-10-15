#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/modbus-rtu -m \
'{
  "client": "xrt modbus-rtu example",
  "request_id": "1022",
  "op": "device:read_batch",
  "type": "xrt.request:1.0",
  "devices": [
    "modbus-sim-01",
    "modbus-sim-02",
    "modbus-sim-03"
  ]
}'
