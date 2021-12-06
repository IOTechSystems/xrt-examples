#!/bin/sh

mosquitto_pub -t xrt/schedule/opc_ua_device_service/request -m \
'{
  "client":"example",
  "request_id": "1040",
  "op": "schedule:add",
  "schedule": {
    "name":"opc-ua-sim-schedule1",
    "device":"opc-ua-sim",
    "resource":["ns=3;s=Random"],
    "interval": 1000000
  }
}'
