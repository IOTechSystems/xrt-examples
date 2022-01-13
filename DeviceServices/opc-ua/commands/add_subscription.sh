#!/bin/sh

mosquitto_pub -t xrt/devices/opc_ua/request -m \
'{
  "client":"example",
  "request_id": "1050",
  "op": "schedule:add",
  "schedule": {
    "name":"opc-ua-sim-subscription1",
    "device":"opc-ua-sim",
    "resource":["ns=3;s=Counter"],
    "interval": 1000000,
    "options" : {
      "Subscription" : {
        "Interval" : 0
      }
    }
  }
}'
