#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/virtual -m \
'{
  "client":"example",
  "request_id": "1040",
  "op": "schedule:add",
  "type": "xrt.request:1.0",
  "schedule": {
    "name":"virtual-schedule1",
    "device":"Virtual-Device",
    "resource":["RandomInt8","CountingUpFloat32"],
    "interval": 2000000
  }
}'
