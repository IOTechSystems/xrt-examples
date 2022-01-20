#!/bin/sh

mosquitto_pub -t xrt/devices/virtual/request -m \
'{
  "client":"example",
  "request_id": "1040",
  "op": "schedule:add",
  "schedule": {
    "name":"virtual-schedule1",
    "device":"Random-Device",
    "resource":["RandomInt8","CountingUInt32"],
    "interval": 2000000
  }
}'
