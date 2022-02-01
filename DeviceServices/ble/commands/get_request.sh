#!/bin/sh

mosquitto_pub -t xrt/devices/ble/request -m \
'{
  "client": "example",
  "request_id": "1020",
  "op": "device:get",
  "device": "ble-sim",
  "resource": ["Square"]
}'
