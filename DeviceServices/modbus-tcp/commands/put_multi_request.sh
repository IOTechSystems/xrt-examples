#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/modbus-tcp -m \
'{
  "client": "example",
  "request_id": "1030",
  "op": "device:put",
  "type": "xrt.request:1.0",
  "device": "modbus-sim",
  "values": {
    "Current": 100,
    "Power": 50,
    "Voltage": 30,
  },
}'
