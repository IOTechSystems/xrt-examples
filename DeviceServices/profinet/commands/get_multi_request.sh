#!/bin/sh

mosquitto_pub -t xrt/devices/profinet/request -m \
'{
  "client": "example",
  "request_id": "1021",
  "op": "device:get",
  "type": "xrt.request:1.0",
  "device": "netHAT",
  "resource": ["InputUint32", "InputUint16-offset-5"]
}'
