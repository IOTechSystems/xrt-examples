#!/bin/sh

mosquitto_pub -t xrt/schedule/ethernet_ip/request -m \
'{
  "client":"example",
  "request_id": "1040",
  "op": "schedule:add",
  "schedule": {
    "name":"ethernetip-sim-sched1",
    "device":"ethernetip-sim",
    "resource":["DI1"],
    "interval": 1000000
  }
}'
