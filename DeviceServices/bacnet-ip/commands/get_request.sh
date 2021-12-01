#!/bin/sh

mosquitto_pub -t xrt/device/bacnet_ip_device_service/request -m \
'{
  "client": "example",
  "request_id": "1020",
  "op": "device:get",
  "device": "bacnet-ip-sim",
  "resource": ["analog_input_0:present-value"]
"]
}'
