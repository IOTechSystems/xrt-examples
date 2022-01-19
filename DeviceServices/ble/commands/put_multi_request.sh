#!/bin/sh
mosquitto_pub -t xrt/devices/ble/request -m \
'{
  "client": "example",
  "request_id": "1030",
  "op": "device:put",
  "device": "ble-sim",
  "values": {
    "CharOneData": 43,
    "CharTwoFirstData": 123456,
    "CharTwoSecondData": 987654321
  },
}'
