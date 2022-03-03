#!/bin/sh

mosquitto_pub -t xrt/devices/opc_ua/request -m \
'{
  "client": "example",
  "request_id":"1011",
  "op": "device:delete",
  "device": "opc-ua-sim"
}'
