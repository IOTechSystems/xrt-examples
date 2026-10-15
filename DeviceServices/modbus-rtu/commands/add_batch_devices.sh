#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/modbus-rtu -m \
'{
  "client": "xrt modbus-rtu example",
  "request_id": "1020",
  "op": "device:add_batch",
  "type": "xrt.request:1.0",
  "devices": [
    {
      "device": "modbus-sim-01",
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
    },
    {
      "device": "modbus-sim-02",
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
    },
    {
      "device": "modbus-sim-03",
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
    }
  ]
}'
