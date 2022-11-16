#!/bin/sh

mosquitto_pub -t xrt/devices/s7/request -m \
'{
  "client": "example",
  "request_id": "1090",
  "op": "device:put",
  "type": "xrt.request:1.0",
  "device": "s7-sim",
  "values": {
    "DB_1_UI8": 254",
    "DB_1_UI16": 12345,
    "DB_1_UI32": 54321,
    "DB_1_UI64": 987654321,
    "DB_1_I8": -126,
    "DB_1_I16": -1234,
    "DB_1_I32": -123456,
    "DB_1_I64": -42,
    "DB_1_F32": 43.345,
    "DB_1_F64": 123.321,
    "DB_1_String_Test": "Example"
  },
}'
