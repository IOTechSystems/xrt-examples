#!/bin/sh

mosquitto_pub -t xrt/devices/virtual/request -m \
'{
  "client": "example",
  "request_id": "1010",
  "op": "device:add",
  "type": "xrt.request:1.0",
  "device": "Virtual-Device",
  "device_info":  {
    "profileName": "device-virtual",
    "protocols":{
      "Virtual": {}
    }
  }
}'
