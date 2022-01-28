#!/bin/sh

mosquitto_pub -t xrt/devices/modbus/request -m \
'{
  "client": "example",
  "request_id":"1011",
  "op": "device:delete",
  "device": "modbus-sim"
}'
