#!/bin/sh

mosquitto_pub -t xrt/devices/ble/request -m \
'{
  "client":"example",
  "request_id": "1040",
  "op": "schedule:add",
  "schedule": {
    "name":"ble-sim-schedule1",
    "device":"ble-sim",
    "resource":["Sinusoid"],
    "interval": 1000000
  }
}'
