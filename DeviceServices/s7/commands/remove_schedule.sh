#!/bin/sh

mosquitto_pub -t xrt/devices/s7/request -m \
'{
  "client":"example",
  "request_id": "1041",
  "op": "schedule:delete",
  "schedule": "s7-sim-schedule1"
}'
