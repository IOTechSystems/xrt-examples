#!/bin/sh

mosquitto_pub -t xrt/devices/opc_ua/request -m \
'{
  "client": "example",
  "request_id":"1060",
  "op": "device:add",
  "device": "opc-ua-sim",
  "device_info":  {
    "protocols":{
      "OPC-UA":{
        "Address": "localhost:49947",
        "Security": "None"
      }
    }
  }
}'
