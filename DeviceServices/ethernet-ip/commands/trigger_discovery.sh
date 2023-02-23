#!/bin/sh

mosquitto_pub -t xrt/devices/ethernet_ip/request -m \
'{
  "client":"example",
  "request_id": "1060",
  "op": "discovery:trigger",
  "type": "xrt.request:1.0"
}'
