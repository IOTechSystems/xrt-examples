#!/bin/sh

mosquitto_pub -t xrt/devices/modbus/request -m \
'{
  "client": "example",
  "request_id":"1012",
  "op": "profile:delete",
  "profileName": "modbus-sim-profile"
}'
