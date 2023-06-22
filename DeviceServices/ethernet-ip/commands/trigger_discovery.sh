#!/bin/sh

mosquitto_pub -t spBv1.0/iotech/REQUEST/xrt/ethernet_ip -m \
'{
  "client":"example",
  "request_id": "1060",
  "op": "discovery:trigger",
  "type": "xrt.request:1.0"
}'
