#!/bin/sh

mosquitto_pub -t xrt/devices/bacnet_ip/request -m \
'{
  "client": "example",
  "request_id": 1020,
  "op": "device:get",
  "device": "bacnet-ip-sim",
  "resource": ["analog_input_0:present-value"]
}'
