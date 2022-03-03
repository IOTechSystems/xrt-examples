#!/bin/sh

mosquitto_pub -t xrt/devices/opc_ua/request -m \
'{
  "client": "example",
  "request_id": "1020",
  "op": "device:get",
  "device": "opc-ua-sim",
  "resource": ["ns=3;s=Counter"]
}'
