#!/bin/sh

mosquitto_pub -t xrt/devices/ethercat/request -m \
'{
  "client":"example",
  "request_id": "1041",
  "op": "schedule:delete",
  "type": "xrt.request:1.0",
  "schedule": "ethercat-schedule1"
}'
