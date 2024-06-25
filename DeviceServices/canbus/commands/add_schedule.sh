#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/canbus -m \
'{
  "client":"example",
  "request_id": "1040",
  "op": "schedule:add",
  "type": "xrt.request:1.0",
  "schedule": {
    "name":"canbus-example-schedule1",
    "device":"canbus-device",
    "resource":[".*"],
    "on_change": true,
    "options": { "Cyclic": true },
    "interval": 1000000
  }
}'
