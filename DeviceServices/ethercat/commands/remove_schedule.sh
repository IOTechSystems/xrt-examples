#!/bin/sh

mosquitto_pub -t xrt/devices/ethercat/request -m \
'{
  "client":"example",
  "request_id": "1041",
  "op": "schedule:delete",
  "schedule": "ethercat-schedule1"
}'
