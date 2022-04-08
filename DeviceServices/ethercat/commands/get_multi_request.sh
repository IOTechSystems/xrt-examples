#!/bin/sh

mosquitto_pub -t xrt/devices/ethercat/request -m \
'{
  "client": "example",
  "request_id": "1021",
  "op": "device:get",
  "type": "xrt.request:1.0",
  "device": "XMC4800",
  "resource": ["IN_GEN_BIT1", "IN_GEN_BIT2"]
}'
