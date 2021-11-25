#!/bin/sh

mosquitto_pub -t xrt/device/ethernet_ip_device_service/request -m \
'{
  "client": "example",
  "request_id":"1011",
  "op": "device:delete",
  "device": "ethernetip-sim"
}'
