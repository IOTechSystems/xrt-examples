#!/bin/sh

mosquitto_pub -t xrt/devices/bacnet_mstp/request -m \
'{
  "client":"example",
  "request_id": "1060",
  "op": "discovery:trigger",
  "type": "xrt.request:1.0"
}'
