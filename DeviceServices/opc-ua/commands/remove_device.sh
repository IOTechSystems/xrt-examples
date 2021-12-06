#!/bin/sh

mosquitto_pub -t xrt/device/opc_ua_device_service/request -m \
'{
  "client": "example",
  "request_id":"1011",
  "op": "device:delete",
  "device": "opc-ua-sim"
}'
