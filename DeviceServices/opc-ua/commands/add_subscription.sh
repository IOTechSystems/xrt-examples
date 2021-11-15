#!/bin/sh

mosquitto_pub -t xrt/schedule/opc_ua_device_service/request -m \
'{
  "client":"example",
  "request_id": "1050",
  "op": "schedule:add",
  "schedule": {
    "name":"opc-ua-sim-subscription1",
    "device":"opc-ua-sim",
    "resource":["ns=3;s=Counter"],
    "interval": 0,
    "options" : {
      "Subscription" : {
        "Interval" : 0
      }
    }
  }
}'
