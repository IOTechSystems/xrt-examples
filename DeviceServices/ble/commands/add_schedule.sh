#!/bin/sh

mosquitto_pub -t xrt/devices/ble/request -m \
'{
  "client":"example",
  "request_id": "1040",
  "op": "schedule:add",
  "type": "xrt.request:1.0",
  "schedule": {
    "name":"ble-sim-schedule1",
    "device":"ble-sim",
    "resource":"Counter",
    "interval": 1000000
  }
}'
