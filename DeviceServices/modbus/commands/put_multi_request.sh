#!/bin/sh
mosquitto_pub -t xrt/devices/modbus/request -m \
'{
  "client": "example",
  "request_id": "1030",
  "op": "device:put",
  "device": "modbus-sim",
  "values": {
    "ns=2;s=WritableInt64": 42,
    "ns=2;s=WritableFloat": 123.456,
    "ns=2;s=WritableString": "Example string",
  },
}'
