#!/bin/sh

mosquitto_pub -t spBv1.0/iotech/REQUEST/xrt/opc_ua -m \
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
