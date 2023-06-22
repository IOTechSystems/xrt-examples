#!/bin/sh

mosquitto_pub -t spBv1.0/iotech/REQUEST/xrt/gps -m \
'{
  "client":"example",
  "request_id": "1041",
  "op": "schedule:delete",
  "type": "xrt.request:1.0",
  "schedule": "gps-sim-schedule1"
}'
