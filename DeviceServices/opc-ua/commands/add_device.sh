#!/bin/sh

mosquitto_pub -t xrt/devices/opc_ua/request -m \
'{
  "client": "example",
  "request_id":"1010",
  "op": "device:add",
  "device": "opc-ua-sim",
  "device_info":  {
    "profileName": "opc-ua-sim-profile",
    "protocols":{
      "OPC-UA":{
        "Address": "localhost:49947",
        "Security": "None"
      }
    }
  }
}'
