#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/opc_ua -m \
'{
  "client":"example",
  "request_id": "1040",
  "op": "schedule:add",
  "type": "xrt.request:1.0",
  "schedule": {
    "name":"opc-ua-sim-schedule1",
    "device":"opc-ua-sim",
    "resource":"ns=3;s=Random:value",
    "interval": 1000000
  }
}'
