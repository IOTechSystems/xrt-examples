#!/bin/sh

mosquitto_pub -t xrt/device/opc_ua_device_service/request -m \
'{
  "client": "example",
  "request_id":"1010",
  "op": "device:add",
  "device": "opc-ua-sim",
  "device_info":  {
    "profile": "opc-ua-sim-profile",
    "protocols":{
      "OPC-UA":{
        "Address": "localhost:49947",
        "Security": "None"
      }
    }
  }
}'
