#!/bin/sh

mosquitto_pub -t xrt/devices/ethernet_ip/request -m \
'{
  "client":"example",
  "request_id": "1040",
  "op": "schedule:add",
  "type": "xrt.request:1.0",
  "schedule": {
    "name":"ethernetip-sim-sched1",
    "device":"ethernetip-sim",
    "resource":"DO1",
    "interval": 1000000
  }
}'
