#!/bin/sh

mosquitto_pub -t xrt/devices/virtual/request -m \
'{
  "client":"example",
  "request_id": "1040",
  "op": "schedule:add",
  "type": "xrt.request:1.0",
  "schedule": {
    "name":"virtual-schedule1",
    "device":"Virtual-Device",
    "resource":["RandomResources"],
    "interval": 2000000
  }
}'
