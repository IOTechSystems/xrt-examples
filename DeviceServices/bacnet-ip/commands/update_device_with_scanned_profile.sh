#!/bin/sh

mosquitto_pub -t xrt/devices/opc_ua/request -m \
'{
  "client":"example",
  "request_id": "1060",
  "op": "device:update",
  "type": "xrt.request:1.0",
  "device": "bacnet-ip-sim",
  "device_info":  { "profileName": "scanned_profile" }
}'
