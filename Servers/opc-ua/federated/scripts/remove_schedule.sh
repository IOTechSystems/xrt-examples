#!/bin/sh

mosquitto_pub -t spBv1.0/iotech/REQUEST/xrt/modbus_tcp -m \
'{
  "client": "example",
  "request_id":"1011",
  "op": "schedule:delete",
  "type": "xrt.request:1.0",
  "schedule": "modbus-example-schedule1"
}'
