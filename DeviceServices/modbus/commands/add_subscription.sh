#!/bin/sh

mosquitto_pub -t xrt/devices/modbus/request -m \
'{
  "client":"example",
  "request_id": "1050",
  "op": "schedule:add",
  "schedule": {
    "name":"modbus-sim-schedule",
    "device":"modbus-sim",
    "resource":["Current"],
    "interval": 1000000,
    "options" : {
      "Subscription" : {
        "Interval" : 0
      }
    }
  }
}'
