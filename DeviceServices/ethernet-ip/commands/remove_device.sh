#!/bin/sh

mosquitto_pub -t xrt/devices/ethernet_ip/request -m \
'{
  "client": "example",
  "request_id":"1011",
  "op": "device:delete",
  "device": "ethernetip-sim"
}'
