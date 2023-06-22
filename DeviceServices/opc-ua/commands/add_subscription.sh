#!/bin/sh

mosquitto_pub -t spBv1.0/iotech/REQUEST/xrt/opc_ua -m \
'{
  "client":"example",
  "request_id": "1050",
  "op": "schedule:add",
  "type": "xrt.request:1.0",
  "schedule": {
    "name":"opc-ua-sim-subscription1",
    "device":"opc-ua-sim",
    "resource":["ns=3;s=Counter:value"],
    "options" : {
      "Subscription" : {
        "Interval" : 0
      }
    }
  }
}'
