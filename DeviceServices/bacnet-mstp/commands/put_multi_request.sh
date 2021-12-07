#!/bin/sh

mosquitto_pub -t xrt/device/bacnet_mstp_device_service/request -m \
'{
  "client": "example",
  "request_id": "1030",
  "op": "device:put",
  "device": "bacnet-mstp-sim",
  "values": {
    "analog_output_0:present-value": 33.23,
    "analog_output_1:present-value": 73.63
  }
}'