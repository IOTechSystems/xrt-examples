#!/bin/sh

mosquitto_pub -t xrt/devices/canbus/request -m \
'{
  "client": "example",
  "request_id": "1010",
  "op": "device:add",
  "type": "xrt.request:1.0",
  "device": "canbus-example",
  "device_info": {
    "profileName": "canbus-profile",
    "protocols": {
      "CANbus": {
          "Network": "can0",
          "NetType": "CAN",
          "Standard": "J1939",
          "ID": 2364539902,
          "DataSize": 8
      }
    }
  }  
}'
