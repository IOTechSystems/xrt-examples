#!/bin/sh

mosquitto_pub -t xrt/devices/opc_ua/request -m \
'{
  "client": "example",
  "request_id": "1030",
  "op": "device:put",
  "type": "xrt.request:1.0",
  "device": "opc-ua-sim",
  "values": {
    "ns=2;s=Int64:value": 42,
  },
}'
