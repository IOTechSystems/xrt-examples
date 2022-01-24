#!/bin/sh

mosquitto_pub -t xrt/devices/modbus/request -m \
'{
  "client":"example",
  "request_id": "1040",
  "op": "schedule:add",
  "schedule": {
    "name":"modbus-sim-schedule1",
    "device":"modbus-sim",
    "resource":["ns=3;s=Random"], //todo: update
    "interval": 1000000
  }
}'
