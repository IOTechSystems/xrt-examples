#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/modbus-tcp -m \
'{
  "client": "xrt modbus-tcp example",
  "request_id": "1020",
  "op": "device:add_batch",
  "type": "xrt.request:1.0",
  "devices": [
    {
      "device": "modbus-sim-01",
      "device_info": {
        "profileName": "modbus-sim-profile",
        "protocols": {
          "modbus-tcp": {
            "Address": "0.0.0.0",
            "Port": 1502,
            "UnitID": 1
          }
        }
      }
    },
    {
      "device": "modbus-sim-02",
      "device_info": {
        "profileName": "modbus-sim-profile",
        "protocols": {
          "modbus-tcp": {
            "Address": "0.0.0.0",
            "Port": 1502,
            "UnitID": 1
          }
        }
      }
    },
    {
      "device": "modbus-sim-03",
      "device_info": {
        "profileName": "modbus-sim-profile",
        "protocols": {
          "modbus-tcp": {
            "Address": "0.0.0.0",
            "Port": 1502,
            "UnitID": 1
          }
        }
      }
    }
  ]
}'
