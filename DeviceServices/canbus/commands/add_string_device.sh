#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/canbus -m \
'{
  "client": "example",
  "request_id": "1010",
  "op": "device:add",
  "type": "xrt.request:1.0",
  "device": "canbus-string-example",
  "device_info": {
    "profileName": "canbus-profile-strings",
    "protocols": {
      "CANbus": {
          "Network": "can0",
          "NetType": "CAN",
          "Standard": "RAW"
      }
    }
  }  
}'
