#!/bin/sh

mosquitto_pub -t xrt/device/opc_ua_device_service/request -m \
'{
  "client": "example",
  "request_id":"1010",
  "op": "device:add",
  "device": "opc-ua-sim",
  "profile": "opc-ua-sim-profile",
  "device_info":  {
    "protocols":{
      "OPC-UA":{
        "Address": "localhost:49947",
        "Security": "None"
      }
    }
  }
}'
