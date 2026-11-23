#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/ble -m \
'{
  "client": "xrt ble example",
  "request_id": "1020",
  "op": "device:add_batch",
  "type": "xrt.request:1.0",
  "devices": [
    {
      "device": "ble-sim-01",
      "device_info":  {
        "profileName": "ble-sim-profile",
        "protocols":{
          "BLE":{
            "MAC": "00:AA:01:01:00:25"
          }
        }
      }
    },
    {
      "device": "ble-sim-02",
      "device_info":  {
        "profileName": "ble-sim-profile",
        "protocols":{
          "BLE":{
            "MAC": "00:AA:01:02:00:26"
          }
        }
      }
    },
    {
      "device": "ble-sim-03",
      "device_info":  {
        "profileName": "ble-sim-profile",
        "protocols":{
          "BLE":{
            "MAC": "00:AA:01:03:00:27"
          }
        }
      }
    }
  ]
}'
