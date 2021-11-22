#!/bin/sh

mosquitto_pub -t xrt/device/bacnet_ip_device_service/request -m \
'{
  "client": "example",
  "request_id":"1011",
  "op": "device:delete",
  "device": "bacnet-sim"
}'
