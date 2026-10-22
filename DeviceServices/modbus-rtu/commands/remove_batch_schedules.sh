#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/modbus-rtu -m \
'{
  "client":"xrt modbus-rtu example",
  "request_id": "1031",
  "op": "schedule:delete_batch",
  "type": "xrt.request:1.0",
  "schedules": [
    "modbus-rtu-schedule1",
    "modbus-rtu-schedule2",
    "modbus-rtu-schedule3"
  ]
}'
