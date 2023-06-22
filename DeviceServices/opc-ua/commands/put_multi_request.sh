#!/bin/sh
mosquitto_pub -t spBv1.0/iotech/REQUEST/xrt/opc_ua -m \
'{
  "client": "example",
  "request_id": "1030",
  "op": "device:put",
  "type": "xrt.request:1.0",
  "device": "opc-ua-sim",
  "values": {
    "ns=2;s=Int64:value": 42,
    "ns=2;s=Float:value": 123.456,
    "ns=2;s=String:value": "Example string",
  },
}'
