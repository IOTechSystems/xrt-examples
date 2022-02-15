#!/bin/sh

mosquitto_pub -t xrt/devices/ethernet_ip/request -m \
'{
  "client": "example",
  "request_id": "1020",
  "op": "device:get",
  "device": "ethernetip-sim",
  "resource": ["DO1"]
}'
