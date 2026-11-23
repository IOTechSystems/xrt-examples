#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/s7 -m \
'{
  "client": "example",
  "request_id": "1020",
  "op": "device:add_batch",
  "type": "xrt.request:1.0",
  "devices": [
    {
      "device": "s7-sim-01",
      "device_info":  {
        "profileName": "Server",
        "protocols":{
          "S7":{
            "IP": "'$S7_SIM_ADDRESS'",
            "Rack": 0,
            "Slot": 2
          }
        }
      }
    },
    {
      "device": "s7-sim-02",
      "device_info":  {
        "profileName": "Server",
        "protocols":{
          "S7":{
            "IP": "'$S7_SIM_ADDRESS'",
            "Rack": 0,
            "Slot": 2
          }
        }
      }
    },
    {
      "device": "s7-sim-03",
      "device_info":  {
        "profileName": "Server",
        "protocols":{
          "S7":{
            "IP": "'$S7_SIM_ADDRESS'",
            "Rack": 0,
            "Slot": 2
          }
        }
      }
    }
  ]
}'
