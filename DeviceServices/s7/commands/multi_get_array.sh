#!/bin/sh

mosquitto_pub -t xrt/devices/s7/request -m \
'{
  "client": "example",
  "request_id": "1050",
  "op": "device:get",
  "type": "xrt.request:1.0",
  "device": "s7-sim",
  "resource": [
    "DB_1_UI8_ARRAY",
    "DB_1_I64_ARRAY"
  ] 
}'
