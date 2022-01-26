#!/bin/sh

mosquitto_pub -t xrt/devices/modbus/request -m \
'{
  "client": "example",
  "request_id":"1010",
  "op": "device:add",
  "device": "modbus-sim",
  "device_info":  {
    "profileName": "modbus-sim-profile",
    "protocols":{
      "modbus-tcp":{
        "Address": "localhost",
        "Port": "1502",
        "UnitID": 1
      }
    }
  }
}'