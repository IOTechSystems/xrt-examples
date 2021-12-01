#!/bin/sh

mosquitto_pub -t xrt/device/bacnet_mstp_device_service/request -m \
'{
  "client": "example",
  "request_id": "1020",
  "op": "device:get",
  "device": "bacnet-mstp-sim",
  "resource": ["analog_input_0:present-value"]
"]
}'
