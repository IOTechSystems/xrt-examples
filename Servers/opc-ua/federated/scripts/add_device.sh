#!/bin/sh

mosquitto_pub -t spBv1.0/iotech/REQUEST/xrt/modbus_tcp -m \
    '{
      "client": "example",
      "request_id":"1010",
      "op": "device:add",
      "type": "xrt.request:1.0",
      "device": "modbus-device1",
      "device_info":  {
        "profileName": "modbus-profile",
        "protocols":{
          "modbus-tcp":{
            "Address": "172.17.0.1",
            "Port": 1502,
            "UnitID": 1
          }
        }
      }
    }'
