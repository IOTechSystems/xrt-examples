#!/bin/sh

mosquitto_pub -t xrt/devices/gps/request -m \
'{
  "client": "example",
  "request_id": "1012",
  "op": "profile:delete",
  "profile": "GPS-Device"
}'