#!/bin/sh

mosquitto_pub -t xrt/devices/gps/request -m \
'{
  "client":"example",
  "request_id": "1041",
  "op": "schedule:delete",
  "schedule": "gps-sim-schedule1"
}'