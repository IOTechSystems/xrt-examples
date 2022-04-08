#!/bin/sh

mosquitto_pub -t xrt/devices/modbus/request -m \
'{
  "client":"example",
  "request_id": "1040",
  "op": "schedule:add",
  "type": "xrt.request:1.0",
  "schedule": {
    "name":"modbus-example-schedule1",
    "device":"modbus-sim",
    "resource":["Current"],
    "interval": 1000000
  }
}'
