#!/bin/sh

mosquitto_pub -t xrt/devices/opc_ua/request -m \
'{
  "client": "example",
  "request_id": "1030",
  "op": "device:put",
  "device": "opc-ua-sim",
  "values": {
    "ns=2;s=WritableInt64": 42,
  },
}'
