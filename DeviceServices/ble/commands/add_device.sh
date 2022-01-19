#!/bin/sh

mosquitto_pub -t xrt/devices/ble/request -m \
'{
  "client": "example",
  "request_id":"1010",
  "op": "device:add",
  "device": "opc-ua-sim",
  "device_info":  {
    "profileName": "ble-sim-profile",
    "protocols":{
      "OPC-UA":{
        "Address": "localhost:49947",
        "Security": "None"
      }
    }
  }
}'
