#!/bin/sh

mosquitto_pub -t xrt/device/ethernet_ip/request -m \
'{
  "client": "example",
  "request_id": "1020",
  "op": "device:get",
  "device": "ethernetip-sim",
  "resource": ["DI1"]
}'
