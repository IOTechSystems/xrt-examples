#!/bin/sh

mosquitto_pub -t spBv1.0/iotech/REQUEST/xrt/modbus-rtu -m \
'{
  "client": "example",
  "request_id": "1010",
  "op": "device:add",
  "type": "xrt.request:1.0",
  "device": "modbus-sim",
  "device_info":  {
    "profileName": "modbus-sim-profile",
    "protocols": {
     "modbus-rtu": {
         "Address": "/tmp/virtualport",
         "BaudRate": 19200,
         "DataBits": 8,
         "Parity": "N",
         "StopBits": 1,
         "UnitID": 1
      }
    }
  }
}'
