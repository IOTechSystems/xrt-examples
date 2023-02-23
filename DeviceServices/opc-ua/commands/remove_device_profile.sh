#!/bin/sh

mosquitto_pub -t xrt/devices/opc_ua/request -m \
'{
  "client": "example",
  "request_id":"1012",
  "op": "profile:delete",
  "type": "xrt.request:1.0",
  "profile": "opc-ua-sim-profile"
}'
