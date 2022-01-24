#!/bin/sh

mosquitto_pub -t xrt/devices/modbus/request -m \
'{
  "client": "example",
  "request_id":"1060",
  "op": "device:add",
  "device": "modbus-sim",
  "device_info":  {
    "protocols":{
      "Modbus":{
        "Address": "localhost:1502",
        "Security": "None"
      }
    }
  }
}'
