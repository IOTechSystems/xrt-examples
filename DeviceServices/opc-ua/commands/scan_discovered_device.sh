#!/bin/sh

mosquitto_pub -t xrt/devices/opc_ua/request -m \
'{
  "client":"example",
  "request_id": "1060",
  "op": "device:scan",
  "type": "xrt.request:1.0",
  "device": "opc-ua-sim",
  "profile": "scanned_profile"
}'
