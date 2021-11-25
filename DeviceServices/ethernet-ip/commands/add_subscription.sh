#!/bin/sh

mosquitto_pub -t xrt/schedule/ethernet_ip_device_service/request -m \
'{
  "client":"example",
  "request_id": "1040",
  "op": "schedule:add",
  "schedule": {
    "name":"ethernetip-sim-sub1",
    "device":"ethernetip-sim",
    "resource":["DI3"],
    "interval": 10,
    "options":{
        "Subscription":{
        "Interval": 0
        }
    }
  }
}'
