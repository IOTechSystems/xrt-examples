#!/bin/sh

mosquitto_pub -t xrt/devices/s7/request -m \
'{
  "client": "example",
  "request_id":"1012",
  "op": "profile:delete",
  "profileName": "Server"
}'
