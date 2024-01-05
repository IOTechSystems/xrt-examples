#!/bin/sh

mosquitto_pub -t xrt/devices/virtual/request -m \
'{
  "client": "example",
  "request_id": "1020",
  "op": "device:get",
  "device": "Random-Device",
  "resource": ["RandomInt16"]
}'