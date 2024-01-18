#!/bin/sh

mosquitto_pub -t xrt/devices/canbus/request -m \
'{
  "client":"example",
  "request_id": "1040",
  "op": "schedule:add",
  "type": "xrt.request:1.0",
  "schedule": {
    "name":"sched-1",
    "device":"canbus-example",
    "resource":[".*"],
    "interval": 1000000,
     "options": {
        "Cyclic": true
      },
      "on_change": true
  }
}'
