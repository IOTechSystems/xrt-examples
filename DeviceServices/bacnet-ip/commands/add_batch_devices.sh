#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/bacnet_ip -m \
'{
  "client": "xrt bacnet_ip example",
  "request_id": "1020",
  "op": "device:add_batch",
  "type": "xrt.request:1.0",
  "devices": [
    {
      "device": "bacnet-ip-sim-device-01",
      "device_info":  {
        "profileName": "bacnet-ip-sim-profile",
        "protocols":{
          "BACnet-IP":{
            "DeviceInstance": 1235
          }
        }
      }
    },
    {
      "device": "bacnet-ip-sim-device-02",
      "device_info":  {
        "profileName": "bacnet-ip-sim-profile",
        "protocols":{
          "BACnet-IP":{
            "DeviceInstance": 1236
          }
        }
      }
    },
    {
      "device": "bacnet-ip-sim-device-03",
      "device_info":  {
        "profileName": "bacnet-ip-sim-profile",
        "protocols":{
          "BACnet-IP":{
            "DeviceInstance": 1237
          }
        }
      }
    }
  ]
}'
