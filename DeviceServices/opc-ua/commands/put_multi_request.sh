#!/bin/sh
mosquitto_pub -t xrt/device/opc_ua_device_service/request -m \
'{
  "client": "example",
  "request_id": "1030",
  "op": "device:put",
  "device": "opc-ua-sim",
  "values": {
    "ns=2;s=WritableInt64": 42,
    "ns=2;s=WritableFloat": 123.456,
    "ns=2;s=WritableString": "Example string",
  },
}'
