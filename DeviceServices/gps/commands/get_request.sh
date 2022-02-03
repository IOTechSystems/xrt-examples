#!/bin/sh

mosquitto_pub -t xrt/devices/gps/request -m \
'{
  "client": "example",
  "request_id": "1020",
  "op": "device:get",
  "device": "gps-sim",
  "resource": ["Date"]
}'