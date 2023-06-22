#!/bin/sh

mosquitto_pub -t spBv1.0/iotech/REQUEST/xrt/s7 -m \
'{
  "client": "example",
  "request_id": "1050",
  "op": "device:get",
  "type": "xrt.request:1.0",
  "device": "s7-sim",
  "resource": [
    "DB_1_UI8",
    "DB_1_UI16",
    "DB_1_UI32",
    "DB_1_UI64",
    "DB_1_I8",
    "DB_1_I16",
    "DB_1_I32",
    "DB_1_I64",
    "DB_1_F32",
    "DB_1_F64",
    "DB_1_String_Test"
  ] 
}'
