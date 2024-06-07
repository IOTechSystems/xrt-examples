#!/bin/sh

mosquitto_pub -t xrt/devices/s7/request -m \
'{
  "client": "example",
  "request_id": "1090",
  "op": "device:put",
  "type": "xrt.request:1.0",
  "device": "s7-sim",
  "values": {
    "DB_1_UI8_ARRAY": [254, 253, 251, 250, 249],
    "DB_1_I64_ARRAY" [-29837, 29837, 77889988, 33443, 123456]
  },
}'
