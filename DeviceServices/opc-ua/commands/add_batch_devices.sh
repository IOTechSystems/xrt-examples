#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/opc_ua -m \
'{
  "client": "example",
  "request_id": "1020",
  "op": "device:add_batch",
  "type": "xrt.request:1.0",
  "devices": [
    {
      "device": "opc-ua-sim-01",
      "device_info":  {
        "profileName": "opc-ua-sim-profile",
        "protocols":{
          "OPC-UA":{
            "Address": "'$OPCUA_SIM_ADDRESS'",
            "Security": "None"
          }
        }
      }
    },
    {
      "device": "opc-ua-sim-02",
      "device_info":  {
        "profileName": "opc-ua-sim-profile",
        "protocols":{
          "OPC-UA":{
            "Address": "'$OPCUA_SIM_ADDRESS'",
            "Security": "None"
          }
        }
      }
    },
    {
      "device": "opc-ua-sim-03",
      "device_info":  {
        "profileName": "opc-ua-sim-profile",
        "protocols":{
          "OPC-UA":{
            "Address": "'$OPCUA_SIM_ADDRESS'",
            "Security": "None"
          }
        }
      }
    }
  ]
}'
