#!/bin/sh

if ( $RTU_MODE == "true") then
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
          "Address": "127.0.0.1",
          "Port": 1502,
          "UnitID": 1
        }
      }
    }
  }'
else 
  mosquitto_pub -t xrt/devices/modbus/request -m \
  '{
    "client": "example",
    "request_id":"1010",
    "op": "device:add",
    "device": "modbus-sim",
    "device_info":  {
      "profileName": "modbus-sim-profile",
      "protocols": {
       "modbus-rtu": {
           "Address": "/dev/ttyUSB0",
           "BaudRate": 9600,
           "DataBits": 8,
           "Parity": "N",
           "StopBits": 1,
           "UnitID": 1
        }
      }
    }
  }'
fi
