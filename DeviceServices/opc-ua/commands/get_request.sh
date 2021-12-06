#!/bin/sh

mosquitto_pub -t xrt/device/opc_ua_device_service/request -m \
'{
  "client": "example",
  "request_id": "1020",
  "op": "device:get",
  "device": "opc-ua-sim",
  "resource": ["ns=3;s=Counter"]
}'