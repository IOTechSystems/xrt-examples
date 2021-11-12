#!/bin/sh

mosquitto_pub -t xrt/schedule/opc_ua_device_service/request -m \
'{
  "client":"example",
  "request_id": "103",
  "op": "schedule:add",
  "schedule": {
    "name":"schedule1",
    "device":"opc-ua-sim",
    "resource":["ns=3;s=Triangle"],
    "interval": 1000000
  }
}'
