#!/bin/sh

mosquitto_pub -t xrt/devices/gps/request -m \
'{
  "client":"example",
  "request_id": "1040",
  "op": "schedule:add",
  "type": "xrt.request:1.0",
  "schedule": {
    "name":"gps-sim-schedule1",
    "device":"gps-sim",
    "resource":"Date",
    "interval": 1000000
  }
}'
