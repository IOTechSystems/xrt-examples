#!/bin/sh

mosquitto_pub -t xrt/devices/bacnet_ip/request -m \
'{
  "client": "example",
  "request_id": "1031",
  "op": "device:put",
  "device": "bacnet-ip-sim",
  "values": {
    "analog_output_0:present-value": 2.75
  }
}'
