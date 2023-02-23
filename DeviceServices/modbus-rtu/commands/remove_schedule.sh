#!/bin/sh

mosquitto_pub -t xrt/devices/modbus/request -m \
'{
  "client":"example",
  "request_id": "1041",
  "op": "schedule:delete",
  "type": "xrt.request:1.0",
  "schedule": "modbus-example-schedule1"
}'
