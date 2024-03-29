#!/bin/sh

mosquitto_pub -t xrt/devices/bacnet_ip/request -m \
'{
  "client": "example",
  "request_id": "1030",
  "op": "device:put",
  "type": "xrt.request:1.0",
  "device": "bacnet-ip-sim",
  "values": {
    "analog_output_0:present-value": 33.23,
    "analog_output_1:present-value": 73.63
  }
}'
