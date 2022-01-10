#!/bin/sh

mosquitto_pub -t xrt/devices/opc_ua/request -m \
'{
  "client":"example",
  "request_id": "1040",
  "op": "schedule:add",
  "schedule": {
    "name":"opc-ua-sim-schedule1",
    "device":"opc-ua-sim",
    "resource":["ns=3;s=Random"],
    "interval": 10000
  }
}'
