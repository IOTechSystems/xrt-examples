#!/bin/sh
mosquitto_pub -t xrt/devices/opc_ua/request -m \
'{
  "client": "example",
  "request_id": "1030",
  "op": "device:put",
  "type": "xrt.request:1.0",
  "device": "opc-ua-sim",
  "values": {
    "ns=3;s=Int64": 42,
    "ns=3;s=Float": 123.456,
    "ns=3;s=String": "Example string",
  },
}'
