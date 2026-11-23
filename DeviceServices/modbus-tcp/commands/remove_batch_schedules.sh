#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/modbus-tcp -m \
'{
  "client":"xrt modbus-tcp example",
  "request_id": "1031",
  "op": "schedule:delete_batch",
  "type": "xrt.request:1.0",
  "schedules": [
    "modbus-tcp-schedule1",
    "modbus-tcp-schedule2",
    "modbus-tcp-schedule3"
  ]
}'
