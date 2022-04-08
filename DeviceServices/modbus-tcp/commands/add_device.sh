#!/bin/sh

mosquitto_pub -t xrt/devices/modbus/request -m \
'{
  "client": "example",
  "request_id":"1010",
  "op": "device:add",
  "type": "xrt.request:1.0",
  "device": "modbus-sim",
  "device_info":  {
    "profileName": "modbus-sim-profile",
    "protocols":{
      'modbus-tcp':{
        "Address": "${MODBUS_SIM_ADDRESS}",
        "Port": 1502,
        "UnitID": 1
      }
    }
  }
}'
