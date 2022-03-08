#!/bin/sh

mosquitto_pub -t xrt/devices/ethercat/request -m \
'{
  "client": "example",
  "request_id": "1020",
  "op": "device:get",
  "device": "XMC4800",
  "resource": ["IN_GEN_BIT1"]
}'
