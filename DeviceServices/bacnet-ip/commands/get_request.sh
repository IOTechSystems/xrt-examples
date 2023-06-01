#!/bin/sh

mosquitto_pub -t spBv1.0/iotech/REQUEST/node0/bacnet_ip -m \
'{
  "client": "example",
  "request_id": "1020",
  "op": "device:get",
  "type": "xrt.request:1.0",
  "device": "bacnet-ip-sim",
  "resource": "analog_input_0:present-value"
}'
