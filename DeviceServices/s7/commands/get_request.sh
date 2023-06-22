#!/bin/sh

mosquitto_pub -t spBv1.0/iotech/REQUEST/xrt/s7 -m \
'{
  "client": "example",
  "request_id": "1020",
  "op": "device:get",
  "type": "xrt.request:1.0",
  "device": "s7-sim",
  "resource": "DB_1_I64"
}'
