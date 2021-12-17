#!/bin/sh

mosquitto_pub -t xrt/devices/bacnet_mstp/request -m \
'{
  "client": "example",
  "request_id": 1021,
  "op": "device:get",
  "device": "bacnet-mstp-sim",
  "resource": [
      "analog_input_0:present-value",
      "analog_input_1:present-value",
      "analog_value_0:present-value",
      "analog_value_1:present-value"
    ]
}'
