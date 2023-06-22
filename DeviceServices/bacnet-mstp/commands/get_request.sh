#!/bin/sh

mosquitto_pub -t spBv1.0/iotech/REQUEST/xrt/bacnet_mstp -m \
'{
  "client": "example",
  "request_id": "1020",
  "op": "device:get",
  "type": "xrt.request:1.0",
  "device": "bacnet-mstp-sim",
  "resource": "analog_input_0:present-value"
}'
