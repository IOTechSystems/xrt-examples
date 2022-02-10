#!/bin/sh

mosquitto_pub -t xrt/devices/s7/request -m \
'{
  "client": "example",
  "request_id":"1011",
  "op": "device:delete",
  "device": "s7-sim"
}'
