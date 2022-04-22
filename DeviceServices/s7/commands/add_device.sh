#!/bin/sh

mosquitto_pub -t xrt/devices/s7/request -m \
'{
  "client": "example",
  "request_id":"1010",
  "op": "device:add",
  "type": "xrt.request:1.0",
  "device": "s7-sim",
  "device_info":  {
    "profileName": "Server",
    "protocols":{
      "S7":{
        "IP": "0.0.0.0",
        "Rack": 0,
        "Slot": 2
      }
    }
  }
}'
