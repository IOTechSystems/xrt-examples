#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/ethercat -m \
'{
  "client": "example",
  "request_id": "1020",
  "op": "device:add_batch",
  "type": "xrt.request:1.0",
  "devices": [
    {
      "device": "EK1100",
      "device_info":  {
        "profileName": "EK1100",
        "protocols":{
          "EtherCAT": {
            "NetworkIndex": 1,
            "SyncMode": 1
          }
        }
      }
    },
    {
      "device": "EL7037",
      "device_info":  {
        "profileName": "EL7037-VelocityDirect",
        "protocols":{
          "EtherCAT": {
            "NetworkIndex": 2,
            "SyncMode": 1
          }
        }
      }
    },
    {
      "device": "XMC4800",
      "device_info":  {
        "profileName": "XMC4800_V3_1",
        "protocols":{
          "EtherCAT": {
            "NetworkIndex": 3,
            "SyncMode": 1
          }
        }
      }
    }
  ]
}'
