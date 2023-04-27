#!/bin/sh

mosquitto_pub -t xrt/devices/opc_ua/request -m \
'{
  "client": "example",
  "request_id":"1060",
  "op": "device:add",
  "type": "xrt.request:1.0",
  "device": "opc-ua-sim",
  "device_info":  {
    "protocols":{
      "OPC-UA":{
        "Address": "'$OPCUA_SIM_ADDRESS'",
        "Security": "None"
      }
    }
  }
}'
