#!/bin/sh

mosquitto_pub -t xrt/schedule/bacnet_ip_device_service/request -m \
'{
  "client":"example",
  "request_id": "1050",
  "op": "schedule:add",
  "schedule": {
    "name":"bacnet-sim-cov1",
    "device":"bacnet-sim",
    "resource":["ns=3;s=Counter"],   // TODO
    "interval": 10,
    "options":{
      "COV":{
        "Confirmed": false,
        "Lifetime": 2000000
      }
    }
  }
}'
