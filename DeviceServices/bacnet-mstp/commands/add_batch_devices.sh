#!/bin/sh

mosquitto_pub -t spBv1.0/${SPARKPLUG_GROUP}/REQUEST/${SPARKPLUG_NODE}/bacnet_mstp -m \
'{
  "client": "xrt bacnet-mstp example",
  "request_id": "1020",
  "op": "device:add_batch",
  "type": "xrt.request:1.0",
  "devices": [
    {
      "device": "bacnet-mstp-sim-01",
      "device_info":  {
        "profileName": "bacnet-mstp-sim-profile",
        "protocols":{
          "BACnet-MSTP":{
            "DeviceInstance": 1234
          }
        }
      }
    },
    {
      "device": "bacnet-mstp-sim-02",
      "device_info":  {
        "profileName": "bacnet-mstp-sim-profile",
        "protocols":{
          "BACnet-MSTP":{
            "DeviceInstance": 1234
          }
        }
      }
    },
    {
      "device": "bacnet-mstp-sim-03",
      "device_info":  {
        "profileName": "bacnet-mstp-sim-profile",
        "protocols":{
          "BACnet-MSTP":{
            "DeviceInstance": 1234
          }
        }
      }
    }
  ]
}'
