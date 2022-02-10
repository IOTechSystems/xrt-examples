#!/bin/sh

mosquitto_pub -t xrt/devices/s7/request -m \
'{
  "client":"example",
  "request_id": "1040",
  "op": "schedule:add",
  "schedule": {
    "name":"s7-sim-schedule1",
    "device":"s7-sim",
    "resource":["DB_1_I64"],
    "interval": 1000000
  }
}'
