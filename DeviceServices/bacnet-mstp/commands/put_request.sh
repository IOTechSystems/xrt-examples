#!/bin/sh

mosquitto_pub -t xrt/devices/bacnet_mstp/request -m \
'{
  "client": "example",
  "request_id": "1031",
  "op": "device:put",
  "type": "xrt.request:1.0",
  "device": "bacnet-mstp-sim",
  "values": {
    "analog_output_0:present-value": 2.75
  }
}'
