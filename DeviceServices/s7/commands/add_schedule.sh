#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/s7 -m \
'{
  "client":"example",
  "request_id": "1040",
  "op": "schedule:add",
  "type": "xrt.request:1.0",
  "schedule": {
    "name":"s7-sim-schedule1",
    "device":"s7-sim",
    "resource":"DB_1_I64",
    "interval": 1000000
  }
}'
