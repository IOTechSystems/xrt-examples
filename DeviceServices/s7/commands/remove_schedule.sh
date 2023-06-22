#!/bin/sh

mosquitto_pub -t spBv1.0/iotech/REQUEST/xrt/s7 -m \
'{
  "client":"example",
  "request_id": "1041",
  "op": "schedule:delete",
  "type": "xrt.request:1.0",
  "schedule": "s7-sim-schedule1"
}'
