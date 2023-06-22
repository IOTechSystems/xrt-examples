#!/bin/sh

mosquitto_pub -t spBv1.0/iotech/REQUEST/xrt/modbus-tcp -m \
'{
  "client": "example",
  "request_id":"1011",
  "op": "device:delete",
  "type": "xrt.request:1.0",
  "device": "modbus-sim"
}'
