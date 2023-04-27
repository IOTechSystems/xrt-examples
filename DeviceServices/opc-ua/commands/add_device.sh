#!/bin/sh

mosquitto_pub -t xrt/devices/opc_ua/request -m \
'{
  "client": "example",
  "request_id":"1010",
  "op": "device:add",
  "type": "xrt.request:1.0",
  "device": "opc-ua-sim",
  "device_info":  {
    "profileName": "opc-ua-sim-profile",
    "protocols":{
      "OPC-UA":{
        "Address": "'$OPCUA_SIM_ADDRESS'",
        "Security": "None"
      }
    }
  }
}'
