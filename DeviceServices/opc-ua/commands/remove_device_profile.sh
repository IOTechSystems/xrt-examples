#!/bin/sh

mosquitto_pub -t xrt/devices/opc_ua/request -m \
'{
  "client": "example",
  "request_id":"1012",
  "op": "profile:delete",
  "profileName": "opc-ua-sim-profile"
}'
