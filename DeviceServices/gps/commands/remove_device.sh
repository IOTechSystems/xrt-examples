#!/bin/sh

mosquitto_pub -t xrt/devices/gps/request -m \
'{
  "client": "example",
  "request_id":"1011",
  "op": "device:delete",
  "device": "gps-sim"
}'
