#!/bin/sh

mosquitto_pub -t xrt/devices/gps/request -m \
'{
  "client":"example",
  "request_id": "1040",
  "op": "schedule:add",
  "schedule": {
    "name":"gps-sim-schedule1",
    "device":"gps-sim",
    "resource":["Date"],
    "interval": 1000000
  }
}'
