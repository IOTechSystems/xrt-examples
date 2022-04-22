#!/bin/sh

mosquitto_pub -t xrt/devices/virtual/request -m \
'{
  "client": "example",
  "request_id": "1010",
  "op": "device:add",
  "type": "xrt.request:1.0",
  "device": "Random-Device",
  "device_info":  {
    "profileName": "device-virtual",
    "protocols":{
      "Other":{
        "Address": "device-virtual-01"
      }
    }
  }
}'
